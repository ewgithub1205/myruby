require 'rubygems'
require 'selenium-webdriver'
require 'net/http' 
class WeiboRobot
   def initialize(name,password)
       @name = name
       @passwd = password
       @commentsTotal = 0
       http = Net::HTTP.new("www.weibo.com", 80)
       http.read_timeout = 500000 
   end

   def send
        #Using Chrom browser
        driver = Selenium::WebDriver.for :chrome
	driver.manage.timeouts.implicit_wait = 300
        driver.get "http://www.weibo.com/login.php"
        sleep 1 
        emailInput = driver.find_element :xpath=> "//input[@node-type='username']"
        sleep 1
        emailInput.send_keys @name
	passwdInput = driver.find_element :xpath=> "//input[@node-type='password']"
        passwdInput.send_keys @passwd
	#Locate signin button
	signButton = driver.find_element :xpath=> "//div[@node-type='normal_form']//div//div//a//span"
        #Fire a weibo to ask xiaobing a question
        wait = Selenium::WebDriver::Wait.new(:timeout => 200)
        begin
             signButton.click
        rescue
               puts "error:#{$!} at:#{$@}"
        end
        wait.until {
             #Print our web page title
            puts "Aready login into Weibo:Page title is #{driver.title}"
            driver.title.downcase.include? "my"
         }
        inputDetail = driver.find_element :xpath=> "//textarea[@node-type='textEl']"
        inputDetail.send_keys get_question
        weiboButton = driver.find_element :xpath=> "//div[@class='func']//a[@node-type='publishBtn']//span"
        sleep 1  
        weiboButton.click
        while true do
             driver.manage.timeouts.implicit_wait = 60000
             driver.manage.timeouts.page_load = 3000000
             driver.get "http://www.weibo.com/comment/inbox"
	     #Print current page title
	     puts "Aready navigate to inbox:Page title is #{driver.title}"
             sleep 3
             commentsSpan = driver.find_element :xpath=> "//span[@node-type='commentNum']"
             commentsNum = commentsSpan.text.to_i
             if commentsNum == @commentsTotal
                 puts "nothing new"
             else
                 @commentsTotal = commentsNum
                 puts "TODO reply"
                 commentInput = driver.find_elements :xpath=> "//div[@node-type='feed_commentList_comment']"
                 #puts commentInput
                 divId=''
                 commentInput.each_with_index {|e,index|
                   if index ==0
                       puts e.attribute("key")
                       divId = e.attribute("key")
                       puts divId
                   end
                 }
                replyLinkElement = driver.find_element :xpath=> "//div[@node-type='feed_commentList_comment' and @key='"+divId +"']//dl//dd//div//p//span//a[@action-type='replycomment']"
                #driver.execute_script("arguments[0].setAttribute(arguments[1],arguments[2])",firstDivElement,"status","show")
                replyLinkElement.click  
                sleep 1
                textAreaElement = driver.find_element :xpath=> "//div[@node-type='feed_commentList_comment' and @key='"+divId +"']//dl//dd//div//div//div//textarea"
                textAreaElement.send_keys get_question
                replyCommentElement = driver.find_element :xpath=> "//div[@node-type='feed_commentList_comment' and @key='"+divId +"']//dl//dd//div//div//div//p//a//span//em"
                replyCommentElement.click 
             end
        end
	#Quit chrome browser
	driver.quit

    end
    def get_question
         "@小冰 "+Random.rand(100).to_s + "+" + Random.rand(100).to_s + "=?" 
    end
end

weiboSender = WeiboRobot.new("xxxxmail126@126.com","xxxx1234qwer")
weiboSender.send
