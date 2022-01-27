
# BACKGROUND
This statistical algorithm attempts to find the best opening move in [Wordle](https://www.powerlanguage.co.uk/wordle/). It uses probabilities of various letters and also combines positional prominence (aka: Greens are more valuable than Yellows which are more valuable than Black) 

TL;DR: The best starting word (based on this statistical analysis) is: *SOARE*

# TOP 10 BEST OPENING WORDS
```
SOARE   0.152995823672924
SAINE   0.152514063946267
SAICE   0.149575587151028
SLANE   0.147529608343559
SLATE   0.144670322024938
SOAVE   0.140929736947304
SHARE   0.140620579004309
SAUTE   0.140550196656936
SAUCE   0.140471006180317
SHALE   0.140454120342594
```

# WORST 10 OPENING WORDS
```
IMMIX   0.0168805116185379
ESSES   0.0192816985492754
XYLYL   0.0219234199190981
EXEEM   0.0228451899070917
HYPHY   0.0233361315893869
EMMEW   0.0235715031409332
OXBOW   0.023593809418905
AYAYA   0.0236096754499411
OPPOS   0.0249141063716357
EXEME   0.0249376004602957
```

# METHODOLOGY
1. Based on all the words in list of Wordle answers (about 2314 words), the algorithm first calculates the *positional probability*. 
    1. e.g. P('A', 'G', 1) - Probability of A being Green in Position 1
2. It then combines that with the *positional prominence*
    1. e.g. GREEN is more value than YELLOW which is more valuable than BLACK
    2. More on how the coefficients for the positional prominence is outlined below
3. It then calculates scores for all the 12970 valid guesses in Wordle (Please note: If you try anything other than these 12970 words, Wordle stops you with "Not in word list" error)

# POSITIONAL PROMINENCE COEFFICIENT CALCULATION
1. How to calculate relative values of G,Y,B
    1. By the amount of Knowledge gain. 
    2. Green means you gained 0.2 (you locked in 1 of 5 tiles)
    3. Yellow means you got a green with 1/4 probability (anything other than the current tile)
    4. Black means you eliminated 1 character out of 26. 
2. COEEFICIENTS
    1. G = 0.2
    2. Y = 0.2 / 4 = 0.05
    3. B = 1/26 = 0.0384

# HOW TO BUILD
1. First install the dependencies
    1. Amazon: ```sudo yum install perl-JSON```
    2. Ubuntu: ```sudo apt-get install -y libjson-perl```
2. Run the program on your favorite dictionary
    1. ```perl run_with_two_lists.pl wordle_answers_plus_allowed_guesses.json wordle_answers_only.json > scores_split_lists_no_repeat_letters.tsv 2> /dev/null```

# WORD LISTS
1. Based on this [sub-reddit](https://www.reddit.com/r/wordle/comments/s4tcw8/a_note_on_wordles_word_list/), here are the two lists used:
    1. [Answers List](https://gist.github.com/a03ef2cba789d8cf00c08f767e0fad7b.git)
    2. [Allowed Guesses](https://gist.github.com/cdcdf777450c5b5301e439061d29694c.git)

# CHANGES (2022-01-27)
```
1. The co-efficient for BLACK seems to be too low. On further thought, 1/26 would be the knowledge gained from a BLACK guess. So fixed that to 1/26 = 0.0384
```

# CHANGES (2022-01-26)
```
1. Calculate probabilities based on answers only.
2. Calculate scores for all guesses (ANSWERS + ALLOWED_GUESSES)
3. Skip adding score when letter is repeated in a word. 
```

# FURTHER READING
1. Wordle uses a subset of the English dictionary. They use two word lists: 
    1. ANSWERS : This is the list of answer words. [Example](https://gist.github.com/a03ef2cba789d8cf00c08f767e0fad7b.git) 
    2. ALLOWED GUESSES: This is the list of allowed guesses. [Example](https://gist.github.com/cdcdf777450c5b5301e439061d29694c.git)
    3. Due to this, a word you think might be a valid English word, might not be allowed. 
2. This is certainly not the only statistical algorithm. Some good ideas are posted in this [sub-Reddit](https://www.reddit.com/r/wordle/comments/s4tcw8/a_note_on_wordles_word_list/)



