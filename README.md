# StudentDebt
Simple little cleaning and graphing of student debt data

This is quick project I made, but I figured I may as well make a readme for everything I do just in case someone wanders across it.

Here's the data: http://ticas.org/posd/state-state-data-2015

I thought it would be interesting after reading an article about rising student debt.  I cleaned the top two lines in excel to make my life a little easier, although I'm sure there's a simple R function to do the same thing.

After that:
  - I removed the asterisks
  - Changed characters to numeric
  - Created latitude and longitude with the package 'maps'
  - Merged the latlon dataframe with the student debt data and created a map
  - Spent far too long trying to get the labels to fit, that's what all the ifelse stuff is for
  
If you find any silly errors or repetitive code, please leave a comment.  I'm always trying to learn.

-Moke
