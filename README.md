# StudentDebt
Simple little cleaning and graphing of student debt data

This is quick project I made, but I figured I may as well make a readme for everything I do just in case someone wanders across it.

Here's the data: http://ticas.org/posd/state-state-data-2015

I thought it would be interesting after reading an article about rising student debt.  I cleaned the top two lines in excel to make my life a little easier, although I'm sure there's a simple R function to do the same thing.  

**Important caveat**: I removed the "Robustness" column because it was not particularly useful to this and there wasn't an easy way to explain it visually.  This column is explained at the bottom of the excel file and gives us an estimate of how reliable the numbers are since there were differing levels of completeness in the creation of the data i.e. for State X, the % of graduates whose student debt we know about could be less in 2014 than 2004 (or likely vice versa) and thus biasing the data.

After that:
  - I removed the asterisks
  - Changed characters to numeric
  - Created latitude and longitude with the package 'maps'
  - Merged the latlon dataframe with the student debt data and created a map
  - Spent far too long trying to get the labels to fit, that's what all the ifelse stuff is for
  
I'm still not sure this is the best way to visualize thisIf you find any silly errors or repetitive code, please leave a comment.  I'm always trying to learn.

-Moke
