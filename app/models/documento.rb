class Documento < ApplicationRecord
  include UnlimitedCache

  def html
    render_contenido[:html]
  end

  def toc
    render_contenido[:toc]
  end

  def title
    render_contenido[:title]
  end

  after_save do
    cache_delete("documento_html_#{id}")
  end

  private

  BOLD = /\*\*(.+?)\*\*/
  ITALIC = /\*(.+?)\*/
  LINK = /\[([^\]]+)\]\(([^)]+)\)/
  HEADING_LINE = /\A(\#{1,6})\s+(.+)\z/
  HR_LINE = /\A-{3,}\z/
  QUOTE_LINE = /\A>\s?(.*)\z/
  UL_ITEM = /\A( *)-\s+(.+)\z/
  OL_ITEM = /\A( *)\.-\s+(.+)\z/
  TABLE_ROW = /\A\|.+\|\z/
  TABLE_SEP = /\A\|[\s:|-]+\|\z/
  RAW_HTML_START = /\A<[a-zA-Z][^>]*>/
  BLOCK_START = Regexp.union(HEADING_LINE, HR_LINE, QUOTE_LINE, UL_ITEM, OL_ITEM, TABLE_ROW, RAW_HTML_START)

  def render_inline(text)
    text.gsub(BOLD, '<strong>\1</strong>')
      .gsub(ITALIC, '<em>\1</em>')
      .gsub(LINK, '<a href="\2">\1</a>')
  end


  def render_contenido
    cache_fetch("documento_html_#{id}") do
      lines = contenido.to_s.split("\n").map(&:rstrip)
      headings = []
      title = nil
      html = +""
      i = 0

      while i < lines.length

        # Saltos de línea en blanco
        if lines[i].empty?
          i += 1
        
        # Cabeceras
        elsif (m = HEADING_LINE.match(lines[i]))
          level = m[1].length
          text = m[2].strip
          anchor = "#{text.parameterize}-#{headings.size}"
          headings << [level, render_inline(text), anchor]
          title ||= text
          html << %(<h#{level} id="#{anchor}">#{render_inline(text)}</h#{level}>\n)
          i += 1

        # Separador horizontal
        elsif HR_LINE.match?(lines[i])
          html << "<hr>\n"
          i += 1

        # Citas
        elsif QUOTE_LINE.match?(lines[i])
          quote_lines = []
          while i < lines.length && (qm = QUOTE_LINE.match(lines[i].strip))
            quote_lines << qm[1]
            i += 1
          end
          html << "<blockquote><p>#{render_inline(quote_lines.join("\n"))}</p></blockquote>\n"

        # Listas
        elsif UL_ITEM.match?(lines[i]) || OL_ITEM.match?(lines[i])
          items = []
          while i < lines.length
            case
            when uli = UL_ITEM.match(lines[i])
              items << [uli[1].length, "ul", uli[2].rstrip]
            when oli = OL_ITEM.match(lines[i])
              items << [oli[1].length, "ol", oli[2].rstrip]
            else
              break
            end
            i += 1
          end

          stack = []
          items.each do |indent, tag, text|
            if stack.empty? || indent > stack.last[0]
              html << "<#{tag}>"
              stack << [indent, tag]
            else
              while stack.size > 1 && indent < stack.last[0]
                html << "</li></#{stack.pop[1]}>"
              end
              html << "</li>"
            end
            html << "<li>#{render_inline(text)}"
          end
          html << "</li>"
          while stack.size > 0
            html << "</#{stack.pop[1]}>"
          end

          html << "\n"

        # Tablas
        elsif TABLE_ROW.match?(lines[i])
          table_lines = []
          while i < lines.length && TABLE_ROW.match?(lines[i].strip)
            table_lines << lines[i].strip
            i += 1
          end
          rows = table_lines.reject { |l| TABLE_SEP.match?(l) }
            .map { |l| l[1..-2].split("|")
            .map { |c| render_inline(c.strip) } }
          header, *body = rows

          html << '<table class="tabla-estadisticas"><thead><tr>'
          header.each { |c| html << "<th>#{c}</th>" }
          html << "</tr></thead><tbody>"
          body.each do |row|
            html << "<tr>"
            row.each { |c| html << "<td>#{c}</td>" }
            html << "</tr>"
          end
          html << "</tbody></table>\n"

        # Bloques de HTML en bruto
        elsif RAW_HTML_START.match?(lines[i])
          while i < lines.length && !lines[i].strip.empty?
            html << lines[i] << "\n"
            i += 1
          end

        # Párrafos
        else
          paragraph_lines = []
          while i < lines.length && !lines[i].strip.empty? && !BLOCK_START.match?(lines[i].strip)
            paragraph_lines << lines[i].strip
            i += 1
          end
          html << "<p>#{render_inline(paragraph_lines.join("\n"))}</p>\n"
        end
      end

      toc = if headings.empty?
        ""
      else
        roots = []
        stack = []

        headings.each do |level, text, anchor|
          node = { text: text, anchor: anchor, children: [] }
          stack.pop while stack.any? && stack.last[0] >= level
          (stack.empty? ? roots : stack.last[1][:children]) << node
          stack.push([level, node])
        end

        roots = roots.first[:children] while roots.size == 1

        if roots.empty?
          ""
        else
          render_nodes = ->(nodes) do
            nodes_html = +"<ul>"
            nodes.each do |n|
              nodes_html << %(<li><a href="##{n[:anchor]}">#{n[:text]}</a>)
              nodes_html << render_nodes.call(n[:children]) unless n[:children].empty?
              nodes_html << "</li>"
            end
            nodes_html << "</ul>"
          end

          %(<nav class="reglas-indice"><h2>Índice</h2>#{render_nodes.call(roots)}</nav>)
        end
      end

      { html: html.html_safe, toc: toc.html_safe, title: title }
    end
  end
end
