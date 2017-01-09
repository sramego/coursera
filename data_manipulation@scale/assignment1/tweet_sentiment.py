import sys
import json 

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    # Parse sentiment scores into dict:scores
    scores = {}
    for line in sent_file:
        term, score = line.split('\t')
        scores[term] = int(score)
    """Parse tweet file to calculate sentiment score
       If tweet line not present output error msg
       Else print sentiment score """
    for tweet in tweet_file:
        temp = json.loads(tweet)    
        sentiment = 0
        if temp.get('text',None) is not None:
            for word in temp.get('text').split():
                sentiment = sentiment + scores.get(word.lower(),0)
            print sentiment
        else:
            print "No tweet text found in line %s" % temp.get('id',None)

if __name__ == '__main__':
    main()
