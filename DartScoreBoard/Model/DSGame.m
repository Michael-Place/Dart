//
//  DSGame.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSGame.h"
#import "DSPlayer.h"

@interface DSGame ()
@property (nonatomic, strong) NSDictionary *scoreValueDictionary;
@property (nonatomic, strong) NSArray *cricketScoreList;

@end

@implementation DSGame
NSString *const CricketScoreStringDoubleBullseye = @"DoubleBullseye";
NSString *const CricketScoreStringBullseye = @"Bullseye";
NSString *const CricketScoreStringTwenty = @"Twenty";
NSString *const CricketScoreStringNineteen = @"Nineteen";
NSString *const CricketScoreStringEighteen = @"Eighteen";
NSString *const CricketScoreStringSeventeen = @"Seventeen";
NSString *const CricketScoreStringSixteen = @"Sixteen";
NSString *const CricketScoreStringFifteen = @"Fifteen";

+ (id)sharedGame
{
    static DSGame *sharedGame = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGame = [[self alloc] init];
    });
    return sharedGame;
}

#pragma mark - Getters
- (NSDictionary *)scoreValueDictionary
{
    if (!_scoreValueDictionary) {
        _scoreValueDictionary = @{CricketScoreStringDoubleBullseye : [NSNumber numberWithInt:CricketScoreValueDoubleBullseye],
                                  CricketScoreStringBullseye : [NSNumber numberWithInt:CricketScoreValueBullseye],
                                  CricketScoreStringTwenty : [NSNumber numberWithInt:CricketScoreValueTwenty],
                                  CricketScoreStringNineteen : [NSNumber numberWithInt:CricketScoreValueNineteen],
                                  CricketScoreStringEighteen : [NSNumber numberWithInt:CricketScoreValueEighteen],
                                  CricketScoreStringSeventeen : [NSNumber numberWithInt:CricketScoreValueSeventeen],
                                  CricketScoreStringSixteen : [NSNumber numberWithInt:CricketScoreValueSixteen],
                                  CricketScoreStringFifteen : [NSNumber numberWithInt:CricketScoreValueFifteen]
                                  };
    }
    return _scoreValueDictionary;
}

- (NSArray *)cricketScoreList
{
    if (!_cricketScoreList) {
        _cricketScoreList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CricketScoreValueList" ofType:@"plist"]];
    }
    return _cricketScoreList;
}

#pragma mark - Game state updater
- (void)incrementScoreValue:(enum CricketScoreValue)value forPlayerNamed:(NSString *)playerName
{
    DSPlayer *player = [self playerWithName:playerName];
    
    [player incrementStrikeCountForScoreValue:value];
    
    [self.delegate updateGameState];
}

- (void)decrementScoreValue:(enum CricketScoreValue)value forPlayerNamed:(NSString *)playerName
{
    DSPlayer *player = [self playerWithName:playerName];
    
    [player decrementStrikeCountForScoreValue:value];
    
    [self.delegate updateGameState];
}


#pragma mark - Helpers
- (DSPlayer *)playerWithName:(NSString *)name
{
    DSPlayer *playerToReturn;
    for (DSPlayer *player in self.players) {
        if ([player.playerName isEqualToString:name]) {
            playerToReturn = player;
        }
    }
    return playerToReturn;
}

+ (enum CricketScoreValue)scoreValueForIndex:(int)index
{
    NSString *cricketValueString = [DSGame sharedGame].cricketScoreList[index];
    int scoreValue = [self scoreValueForKeyString:cricketValueString];
    return scoreValue;
}

+ (NSString *)keyStringForCricketScoreValue:(enum CricketScoreValue)scoreValue
{
    NSString *keyForScoreValue = [[[[DSGame sharedGame] scoreValueDictionary] allKeysForObject:[NSNumber numberWithInt:scoreValue]] lastObject];
    
    return keyForScoreValue;
}

+ (enum CricketScoreValue)scoreValueForKeyString:(NSString *)keyString
{
    enum CricketScoreValue scoreValue = (int)[[[[DSGame sharedGame] scoreValueDictionary] objectForKey:keyString] integerValue];
    
    return scoreValue;
}

@end