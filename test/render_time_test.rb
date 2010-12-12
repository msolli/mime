require "selenium-webdriver"

t1 = Time.now
driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://localhost:3000/articles/new"

driver.quit

total = Time.now - t1

p [total.to_i, total - total.to_i]

printf("%ds%dms", total.to_i, (total - total.to_i) * 1000)
