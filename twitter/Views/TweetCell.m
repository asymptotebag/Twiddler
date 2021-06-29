//
//  TweetCell.m
//  
//
//  Created by Emily Jiang on 6/28/21.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code to config default and selected button states
    [self.favButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    [self.favButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
    
    [self.rtButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    [self.rtButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
    
    [self refreshData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData { //updates cell UI (not any internal tweet info, that should already be changed)
    self.favCount.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.rtCount.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
}

- (IBAction)didTapFav:(id)sender {
    // check if it's already favorited
    if (self.tweet.favorited) { // already fav'd, now unfav it
        self.tweet.favorited = false;
        self.tweet.favoriteCount -= 1;
        self.favButton.selected = false;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Unfavorited tweet: %@", tweet.text);
            }
        }];
    } else { // favorite tweet
        // Update the local tweet model
        self.tweet.favorited = true;
        self.tweet.favoriteCount += 1;
        self.favButton.selected = true;
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Favorited tweet: %@", tweet.text);
            }
        }];
    }
    // Update cell UI
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
    // check if it's already retweeted
    if (self.tweet.retweeted) { // unretweet it
        self.tweet.retweeted = false;
        self.tweet.retweetCount -= 1;
        self.rtButton.selected = false;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting: %@", error.localizedDescription);
            } else {
                NSLog(@"Unretweeted: %@", tweet.text);
            }
        }];
    } else { // retweet it
        // update locally
        self.tweet.retweeted = true;
        self.tweet.retweetCount += 1;
        self.rtButton.selected = true;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting: %@", error.localizedDescription);
            } else {
                NSLog(@"Retweeted: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

@end
