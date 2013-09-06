#import "BadWordList.h"









@implementation CharacterNode

@synthesize c, children, leaf;

- (id)initWithUnichar:(char)cc {
	if ((self = [super init])) {
		c = cc;
		children = NULL;
	}
	return self;
}
+ (CharacterNode *)nodeWithUnichar:(char)cc {
	return [[[CharacterNode alloc] initWithUnichar:cc] autorelease];
}
- (void)addNode:(CharacterNode *)node {
	children = (CharacterNode *)realloc(children, ++numChildren * class_getInstanceSize([CharacterNode class]));
	void *location = (char *)children + class_getInstanceSize([CharacterNode class]) * (numChildren - 1);
	memcpy(location, node, class_getInstanceSize([CharacterNode class]));
}
- (CharacterNode *)nodeAtIndex:(uint8_t)index {
	return (CharacterNode *)((char *)children + class_getInstanceSize([CharacterNode class]) * index);
}
- (CharacterNode *)lastNode {
	if (numChildren) {
		return [self nodeAtIndex:numChildren - 1];
	}
	return nil;
}
- (BOOL)isEqual:(id)other {
	return self.c == ((CharacterNode *)other).c;
}
- (NSUInteger)hash {
	return self.c;
}
- (CharacterNode *)nodeContainingUnichar:(char)cc {
	for (uint8_t i = 0; i < numChildren; i++) {
		CharacterNode *node = (CharacterNode *)((char *)children + class_getInstanceSize([CharacterNode class]) * i);
		if (node.c == cc) return node;
	}
	return nil;
}
- (void)freeChildren {
	for (uint8_t i = 0; i < numChildren; i++) {
		CharacterNode *node = (CharacterNode *)((char *)children + class_getInstanceSize([CharacterNode class]) * i);
		[node freeChildren];
	}
	free(children);
}
@end










@implementation RootCharacterNode
- (id)initWithFilePath:(NSString *)filePath {
	if ((self = [super init])) {
		NSString *fileString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
		NSAutoreleasePool *outerPool = [NSAutoreleasePool new];
		NSArray *lines = [fileString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		[fileString release];
		for (NSString *s in lines) {
			NSAutoreleasePool *innerPool = [NSAutoreleasePool new];
			[self addWord:s];
			[innerPool drain];
		}
		[outerPool drain];
	}
	return self;
}

- (void)addWord:(NSString *)word {
	CharacterNode *currentNode = self;
	for (int i = 0; i < [word length]; i++) {
		CharacterNode *temp = [currentNode nodeContainingUnichar:[word characterAtIndex:i]];
		if (!temp) {
			temp = [CharacterNode nodeWithUnichar:[word characterAtIndex:i]];
			if (i == [word length] - 1) {
				temp.leaf = YES;
			}
			[currentNode addNode:temp];
			temp = [currentNode lastNode];
		}
		else if (i == [word length] - 1) {
			temp->leaf = YES;
			return;
		}
		currentNode = temp;
	}
}
- (BOOL)isWord:(NSString *)word {
	word = [word lowercaseString];
	CharacterNode *currentNode = self;
	for (int i = 0; i < [word length]; i++) {
		CharacterNode *temp = [currentNode nodeContainingUnichar:[word characterAtIndex:i]];
		if (!temp) {
			return NO;
		}
		currentNode = temp;
	}
	return currentNode.leaf;
}
- (void)dealloc {
	[self freeChildren];
	[super dealloc];
}
@end

















@implementation BadWordList
- (id)init {
	if ((self = [super init])) {
		root = [[RootCharacterNode alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"BadWords" ofType:@"txt"]];
	}

	return self;
}
- (NSString *)isAnyOfTheWordFoundIn:(NSString *)string {
	NSSet *words = [NSSet setWithArray:[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	for (NSString *word in words) {
		if ([self isWord:word]) {
			return word;
		}
	}
	return nil;
}
- (BOOL)isWord:(NSString *)word {
	return [root isWord:word];
}
- (void)dealloc {
	[root release];
	[super dealloc];
}
@end
