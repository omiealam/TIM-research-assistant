require 'watir'
require 'open-uri'
require 'set'

YEARS = (2001..2021).to_a # Recent years in the Unicode® Technical Committee Document Registry that share a common URL format
BROWSER = Watir::Browser.new(:chrome, headless: true)
EXTENSIONS = %w(pdf html htm txt) # These are the file extensions we support (TODO .doc, .xlsx, .zip, .pptx)
EMPTY_INDICATOR = %w(<font color=, &nbsp;)  # These indicate empty cells

def url_generator(year)
  return "https://www.unicode.org/L2/L#{year}/Register-#{year}.html"
end

def table(url)
  BROWSER.goto url
  return BROWSER.table(:class => "subtle")
end

def get_table_size(table)
  return (1..(table.rows.length - 1)).to_a # => Returns a range that spans the number of rows of the table (excluding the header)
end

def get_element_extension(table_element)
  return table_element.link.href.split(".").last # => Returns the file extension that a given HTML table element links to
end

def get_extensions_year(year)
  table = table(url_generator(year))
  output = Set[]
  get_table_size(table).each do |index|
    output.add(get_element_extension(table[index][0]))
  end
  return output # => Returns a set of all the files extensions present in that year's document archive
end

def get_all_extensions
  output = Set[]
  YEARS.each do |year|
    output.merge(get_extensions_year(year))
  end
  return output
end

def get_outliers_year(year)
  output = []
  table = table(url_generator(year))
  get_table_size(table).each do |index|
    curr_el = table[index][0]
    output.append(curr_el.inner_text) if !EXTENSIONS.include?(get_element_extension(curr_el))
  end
  return output
end

def get_table_year(year)
  return table(url_generator(year))
end

def save_pdf(el, year)
  File.open("/Users/omar/TIM/UTC-doc-registry/#{year}/#{el.innertext}.pdf", "wb") {|f| f.write URI.open(el.link.href).read }
end

def save_other(el, year)
  extension = get_element_extension(el)
  #el.click
  File.open("/Users/omar/TIM/UTC-doc-registry/#{year}/#{el.innertext}.#{extension}", "wb") {|f| f.write URI.open(el.link.href).read }
end

def scrape_year(year)
    table = get_table_year(year)
    get_table_size(table).each do |index|
      curr_el = table[index][0]
      next if !curr_el.link.exists?

      curr_el_extension = get_element_extension(curr_el)
      begin
        save_pdf(curr_el, year) if curr_el_extension == 'pdf'
        save_other(curr_el, year) if (%w(txt htm html)).include?(curr_el_extension)
      rescue OpenURI::HTTPError => error
        puts curr_el.innertext
      end
    end
end

def scrape_all
  YEARS.each {|year| scrape_year(year) }
end

# special cases: L2/01-071, L2/01-483, L2/01-440

# For HTM only => make sure this can handle HTML, txt
#temp[2][0].click
#File.open('TIM/test.txt', 'w') {|f| f.write BROWSER.html }

# For PDF
#
# .link.href
