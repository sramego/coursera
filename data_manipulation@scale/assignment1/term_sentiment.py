import json
import sys

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    # Get the sentiment scores in dict
    scores = {}
    for line in sent_file:
        term, score = line.split('\t')
        scores[term] = int(score)
    '''Scrub through tweets to get general sentiment
       Save the non-sentiment words in each tweet in lowercase
       with count of occurences of positive (>0) and negative (<0)'''
    result = {}
    for tweet_json in tweet_file:
        tweet = json.loads(tweet_json)
        sentiment = 0
        if tweet.get('text',None) is not None:
	    for word in tweet.get('text').split():
                sentiment = sentiment + scores.get(word.lower(),0)
            for word in tweet.get('text').split():
                if scores.get(word.lower(),None) is None:
                    # Store the non sentiment word or update the count
                    w = word.lower()
                    if sentiment < 0:
                        if w not in result:
                            result.setdefault(w,{'pcount': 1, 'ncount': 2})
                        else:
                            result[w]['ncount'] = result[w]['ncount']+1
                    elif sentiment > 0:
                        if w not in result:
                            result.setdefault(w,{'pcount': 2, 'ncount': 1})
                        else:
                            result[w]['pcount'] = result[w]['pcount']+1
    #Print final unique list of non sentiment words with their sentiment score
    for key in result.keys():
        try:
            print "%s %s" % (key.encode('utf-8'),result[key]['pcount']/float(result[key]['ncount']))
        except ZeroDivisionError:
            print "%s 0" % key.encode('utf-8')
            
if __name__ == '__main__':
    main()
