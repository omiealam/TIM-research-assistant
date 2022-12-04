require 'watir'
require 'open-uri'
require 'set'

RESOLVED_ISSUE_RANGE = (177..459).to_a
OPEN_ISSUE_RANGE = (460..466).to_a
BROWSER = Watir::Browser.new(:chrome, headless: true)
FEEDBACK_STRING_TO_AVOID = "For information about how to discuss this Public Review Issue and how to supply formal feedback"

def pri_url_generator(issue_number)
  return "https://www.unicode.org/review/pri#{issue_number}/"
end

def feedback_url_generator(issue_number)
   return "https://www.unicode.org/review/pri#{issue_number}/feedback.html"
end

def pri_page_scraper(issue_number)
  BROWSER.goto(pri_url_generator(issue_number))
  # puts BROWSER.trs[3].inner_text.split("\n").first
  BROWSER.ps.each {|p| puts p.inner_text if !p.contains?(For information about how to discuss this Public Review Issue and how to supply formal feedback")
end
