require 'commaparty'
require 'cape-cod'

class SonicHarryPotterObama
  class BoolToChar
    def call(bool)
      if bool
        '✓'
      else
        '𝘹'
      end
    end
  end

  class PresentTerminalTable
    def call(results)
      Terminal::Table.new(rows: results.map { |result| present(result) }, style: { border_x: '–' }).to_s
    end

    private

    def present(result)
      [BoolToChar.new.call(result.first), *result[1..-1]].map { |r| colorize(result.first, r) }
    end

    def colorize(found, s)
      if found
        colorize_found(s)
      else
        s
      end
    end

    def colorize_found(s)
      CapeCod.fg(0, 255, 0, s)
    end
  end

  class PresentEmail
    def call(results)
      CommaParty.markup(
        [:table,
         results.map { |result|
          [:tr,
           present(result).map { |r|
            [:td, r]
          }]
        }])
    end
    private

    def present(result)
      [BoolToChar.new.call(result.first), *result[1..-1]]
    end
  end
end

