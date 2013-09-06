#import <Foundation/Foundation.h>


@interface CharacterNode : NSObject {
	char c;
	bool leaf;
	uint8_t numChildren;
	CharacterNode *children;
}
@property (nonatomic, readonly) char c;
@property (nonatomic, readonly) CharacterNode *children;
@property (nonatomic, assign) bool leaf;
- (id)initWithUnichar:(char)cc;
- (void)addNode:(CharacterNode *)node;
+ (CharacterNode *)nodeWithUnichar:(char)cc;
- (CharacterNode *)nodeAtIndex:(uint8_t)index;
- (CharacterNode *)lastNode;
- (CharacterNode *)nodeContainingUnichar:(char)cc;
- (void)freeChildren;
@end




@interface RootCharacterNode : CharacterNode
- (id)initWithFilePath:(NSString *)filePath;
- (void)addWord:(NSString *)word;
- (BOOL)isWord:(NSString *)word;
@end




@interface BadWordList : NSObject{
	RootCharacterNode *root;
}
- (id)init;
- (NSString *)isAnyOfTheWordFoundIn:(NSString *)string;
@end
