puts
=begin
    This is used to login Gmail with Usename and Password,after successfull login
 send an email to itself ,and the refresh inbox to check if got the mail.
=end

require 'rubygems'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "http://www.gmail.com"

sleep 3

emailInput = driver.find_element(:name, 'Email')
emailInput.send_keys "javaok123"

passwordInput = driver.find_element(:name, 'Passwd')

passwordInput.send_keys "1234Qwerasdfzxcv"

loginSubmit = driver.find_element(:name, 'signIn')

loginSubmit.submit

sleep 20 

composeButton = driver.find_element(:class,"z0")

composeButton.click

sleep 20

toInput = driver.find_element(:class, "vO")

toInput.send_keys "javaok123@gmail.com"

subjectInput = driver.find_element(:name,"subjectbox")

subjectInput.send_keys "testing_mail"


#sendButton = driver.find_element(:id,":12b")

sendButton = driver.find_element(:class,"T-I.J-J5-Ji.aoO.T-I-atl.L3")
puts "sendButton"+sendButton.text
sleep 3 
puts sendButton.text
sendButton.click

sleep 1
#Refresh inbox
driver.navigate.to "https://mail.google.com/mail/u/0/#inbox"
sleep 3
puts driver.title

#driver.quit
