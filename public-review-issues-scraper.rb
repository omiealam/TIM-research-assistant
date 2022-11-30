require 'watir'
require 'open-uri'
require 'set'

RESOLVED_ISSUE_RANGE = (177..459).to_a
OPEN_ISSUE_RANGE = (460..466).to_a
BROWSER = Watir::Browser.new(:chrome, headless: true)

def url_generator(year)
  return "https://www.unicode.org/L2/L#{year}/Register-#{year}.html"
end
