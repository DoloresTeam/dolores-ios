//
//  DLMessageModel.m
//  Dolores
//
//  Created by Heath on 25/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLMessageModel.h"

@implementation DLMessageModel

- (instancetype)initWithMessage:(EMMessage *)message {
    self = [super init];
    if (self) {
        _cellHeight = -1;
        _message = message;
        _firstMessageBody = message.body;
        _isMediaPlaying = NO;

        _nickname = message.from;
        _isSender = EMMessageDirectionSend == message.direction;

        switch (_firstMessageBody.type) {
            case EMMessageBodyTypeText: {
                EMTextMessageBody *textBody = (EMTextMessageBody *) _firstMessageBody;
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:textBody.text];
                self.text = didReceiveText;
            }
                break;
            case EMMessageBodyTypeImage: {
                EMImageMessageBody *imgMessageBody = (EMImageMessageBody *) _firstMessageBody;
                NSData *imageData = [NSData dataWithContentsOfFile:imgMessageBody.localPath];
                if (imageData.length) {
                    self.image = [UIImage imageWithData:imageData];
                }

                if ([imgMessageBody.thumbnailLocalPath length] > 0) {
                    self.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
                } else {
                    CGSize size = self.image.size;
                    self.thumbnailImage = size.width * size.height > 200 * 200 ? [self scaleImage:self.image toScale:sqrt((200 * 200) / (size.width * size.height))] : self.image;
                }

                self.thumbnailImageSize = self.thumbnailImage.size;
                self.imageSize = imgMessageBody.size;
                if (!_isSender) {
                    self.fileURLPath = imgMessageBody.remotePath;
                }
            }
                break;
            case EMMessageBodyTypeLocation: {
                EMLocationMessageBody *locationBody = (EMLocationMessageBody *) _firstMessageBody;
                self.address = locationBody.address;
                self.latitude = locationBody.latitude;
                self.longitude = locationBody.longitude;
            }
                break;
            case EMMessageBodyTypeVoice: {
                EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *) _firstMessageBody;
                self.mediaDuration = voiceBody.duration;
                self.isMediaPlayed = NO;
                if (message.ext) {
                    self.isMediaPlayed = [message.ext[@"isPlayed"] boolValue];
                }

                // audio file path
                self.fileURLPath = voiceBody.remotePath;
            }
                break;
            case EMMessageBodyTypeVideo: {
                EMVideoMessageBody *videoBody = (EMVideoMessageBody *) message.body;
                self.thumbnailImageSize = videoBody.thumbnailSize;
                if ([videoBody.thumbnailLocalPath length] > 0) {
                    NSData *thumbnailImageData = [NSData dataWithContentsOfFile:videoBody.thumbnailLocalPath];
                    if (thumbnailImageData.length) {
                        self.thumbnailImage = [UIImage imageWithData:thumbnailImageData];
                    }
                    self.image = self.thumbnailImage;
                }

                // video file path
                self.fileURLPath = videoBody.remotePath;
            }
                break;
            case EMMessageBodyTypeFile: {
                EMFileMessageBody *fileMessageBody = (EMFileMessageBody *) _firstMessageBody;
                self.fileIconName = @"chat_item_file";
                self.fileName = fileMessageBody.displayName;
                self.fileSize = fileMessageBody.fileLength;

                if (self.fileSize < 1024) {
                    self.fileSizeDes = [NSString stringWithFormat:@"%fB", self.fileSize];
                } else if (self.fileSize < 1024 * 1024) {
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fkB", self.fileSize / 1024];
                } else if (self.fileSize < 2014 * 1024 * 1024) {
                    self.fileSizeDes = [NSString stringWithFormat:@"%.2fMB", self.fileSize / (1024 * 1024)];
                }
            }
                break;
            default:
                break;
        }
    }
    return self;
}

#pragma mark - Getter

- (NSString *)messageId {
    return _message.messageId;
}

- (EMMessageStatus)messageStatus {
    return _message.status;
}

- (EMChatType)messageType {
    return _message.chatType;
}

- (EMMessageBodyType)bodyType {
    return self.firstMessageBody.type;
}

- (BOOL)isMessageRead {
    return _message.isReadAcked;
}

- (NSString *)fileLocalPath {
    if (_firstMessageBody) {
        switch (_firstMessageBody.type) {
            case EMMessageBodyTypeVideo:
            case EMMessageBodyTypeImage:
            case EMMessageBodyTypeVoice:
            case EMMessageBodyTypeFile: {
                EMFileMessageBody *fileBody = (EMFileMessageBody *) _firstMessageBody;
                return fileBody.localPath;
            }
                break;
            default:
                break;
        }
    }
    return nil;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
