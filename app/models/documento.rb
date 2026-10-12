class Documento < ApplicationRecord
  include UnlimitedCache

  HEADING_LINE = /\A(\#{1,6})\s+(.+)\z/

  def html
    render_contenido[:html]
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

      toc = if headings.empty?
        ""
      else
        items = headings.map do |level, text, anchor|
          %(<li class="toc-nivel-#{level}"><a href="##{anchor}">#{text}</a></li>)
        end
        %(<ul class="toc">#{items.join}</ul>\n)
      end 

      { html: (toc + html).html_safe, title: title }
    end
  end
end
