require 'watir'
require 'open-uri'
require 'set'

RESOLVED_ISSUE_RANGE = (177..459).to_a
OPEN_ISSUE_RANGE = (460..466).to_a
BROWSER = Watir::Browser.new(:chrome, headless: true)

def url_generator(issue_number)
  return "https://www.unicode.org/review/pri#{issue_number}/"
end
