module Redcarpet
  module Render

    class SyntaxHTML < HTML
      include Redcarpet::Render::SmartyPants

      def initialize(extensions={})
        super(extensions.merge(xhtml: true, hard_wrap: true, with_toc_data: true))
      end

      def header(title, level)
        %Q{
        <h#{level} class="toc-header">#{title} <a class="toc-anchor" href="#toc-#{title.to_url}" id="toc-#{title.to_url}"><i class="icon-link"></i></a></h#{level}>
        }
      end

      def block_code(code, language)
        language = 'cpp' if language == 'c++'
        CodeRay.scan(code, language).div(css: :class)
      rescue
        %Q{<div class="CodeRay"><div class="code"><pre>#{code}</pre></div></div>}
      end
    end

  end

  class Markdown
    @@md_html = Redcarpet::Markdown.new(Redcarpet::Render::SyntaxHTML,
                                        :autolink => true,
                                        :fenced_code_blocks => true,
                                        :strikethrough => true,
                                        :superscript => true,
                                        :space_after_headers => true,
                                        :no_intra_emphasis => true,
                                        :tables => true)

    def self.render(text)
      @@md_html.render(text)
    end
  end
end
