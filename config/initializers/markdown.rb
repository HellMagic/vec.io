module Redcarpet
  module Render

    class SyntaxHTML < HTML
      include Redcarpet::Render::SmartyPants

      def initialize(extensions={})
        super(extensions.merge(xhtml: true, hard_wrap: true, with_toc_data: true))
      end

      def block_code(code, language)
        language = 'c' if language.blank?
        CodeRay.scan(code, language).div(css: :class)
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
