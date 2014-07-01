require 'selenium-webdriver'
require 'nokogiri'

# supply full YouTube URL from command line
link = ARGV[0]

# PhantomJS server
driver = Selenium::WebDriver.for(:remote, :url => "http://localhost:9999")
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

driver.navigate.to link

wait.until { driver.find_element(:class => 'yt-uix-button-icon-action-panel-transcript') }

transcript_button = driver.find_element(:class, 'yt-uix-button-icon-action-panel-transcript')
transcript_button.click

# wait for at least one transcript line
wait.until { driver.find_element(:id => 'cp-1') }

transcript_container = driver.find_element(:id, 'transcript-scrollbox')

cc = Nokogiri::HTML(transcript_container.attribute('innerHTML'))

cc.css('.caption-line').each do |line|
	transcript_line = line.css('.caption-line-time').text.gsub("\n", " ") + " " + line.css('.caption-line-text').text.gsub("\n", " ")
	puts transcript_line
end

driver.quit
