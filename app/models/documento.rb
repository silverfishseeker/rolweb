class Documento < ApplicationRecord
  include UnlimitedCache

  HEADING_LINE = /\A(\#{1,6})\s+(.+)\z/

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

  def render_contenido
    cache_fetch("documento_html_#{id}") do

      headings = []
      title = nil
      html = +""
      paragraph = []

      lines = contenido.to_s.each_line.map(&:strip) + [""]

      lines.each do |line|
        heading_match = HEADING_LINE.match(line)

        if line.empty? || heading_match
          unless paragraph.empty?
            html << "<p>#{paragraph.join("\n")}</p>\n"
            paragraph = []
          end
        else
          paragraph << line
        end

        next unless heading_match

        level = heading_match[1].length
        text = heading_match[2].strip
        anchor = "#{text.parameterize}-#{headings.size}"
        headings << [level, text, anchor]
        title ||= text
        html << %(<h#{level} id="#{anchor}">#{text}</h#{level}>\n)
      end

      # Table of contents generation
      toc = if headings.empty?
        "".html_safe
      else
        toc_html = +"<ul>"
        stack = []

        headings.each do |level, text, anchor|
          if stack.empty?
            stack.push(level)
          elsif level > stack.last
            toc_html << "<ul>"
            stack.push(level)
          else
            while stack.size > 1 && level < stack.last
              toc_html << "</li></ul>"
              stack.pop
            end
            toc_html << "</li>"
            stack[-1] = level
          end
          toc_html << %(<li><a href="##{anchor}">#{text}</a>)
        end

        toc_html << "</li>" << ("</ul></li>" * (stack.size - 1)) << "</ul>"

        %(<nav class="reglas-indice"><h2>Índice</h2>#{toc_html}</nav>).html_safe
      end

      { html: html.html_safe, toc: toc, title: title }
    end
  end
end
