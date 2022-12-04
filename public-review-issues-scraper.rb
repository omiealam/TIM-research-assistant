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
  output_text = BROWSER.trs[3].inner_text.split("\n").first
  output_text << "\n"
  output_text << (BROWSER.ps.map {|p| p.inner_text if !p.inner_text.include?(FEEDBACK_STRING_TO_AVOID)}).join("\n")
  return output_text
end

def feedback_page_scraper(issue_number)
  BROWSER.goto(feedback_url_generator(issue_number))
  return BROWSER.body.inner_text
end

def scraper(issue_number)
  pri_page_text = pri_page_scraper(issue_number)
  File.write("TIM/pri/#{issue_number}.txt", pri_page_text, mode: "a")

  feedback_page_text = feedback_page_scraper(issue_number)
  File.write("TIM/pri/#{issue_number}-accumulated-feedback.txt", feedback_page_text, mode: "a")
end
