//
//  CLUPnPRenderer.m
//  Tiaooo
//
//  Created by ClaudeLi on 16/9/29.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLUPnPRenderer.h"
#import "CLUPnPModel.h"
#import "CLUPnP.h"

@implementation CLUPnPRenderer

- (instancetype)initWithModel:(CLUPnPModel *)model{
    self = [super init];
    if (self) {
        _model = model;
        [self getVolume];
    }
    return self;
}

#pragma mark -
#pragma mark -- 构造主XML --
- (NSString *)prepareXMLFileWithCommand:(GDataXMLElement *)xml serviceType:(NSString *)serviceType{
    GDataXMLElement *xmlEle = [GDataXMLElement elementWithName:@"s:Envelope"];
    [xmlEle addChild:[GDataXMLElement attributeWithName:@"s:encodingStyle" stringValue:@"http://schemas.xmlsoap.org/soap/encoding/"]];
    [xmlEle addChild:[GDataXMLElement attributeWithName:@"xmlns:s" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"]];
    [xmlEle addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceType]];
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"s:Body"];
    [command addChild:xml];
    [xmlEle addChild:command];
    return xmlEle.XMLString;
}

#pragma mark -
#pragma mark -- 构造AVTransport动作XML --
- (void)setAVTransportURL:(NSString *)urlStr{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:SetAVTransportURI"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [command addChild:[GDataXMLElement elementWithName:@"CurrentURI" stringValue:urlStr]];
    [command addChild:[GDataXMLElement elementWithName:@"CurrentURIMetaData"]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceAVTransport];
    [self sendServiceAVTransportWithData:xmlStr action:@"SetAVTransportURI"];
}


- (void)play{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:Play"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [command addChild:[GDataXMLElement elementWithName:@"Speed" stringValue:@"1"]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceAVTransport];
    [self sendServiceAVTransportWithData:xmlStr action:@"Play"];
}

- (void)pause{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:Pause"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceAVTransport];
    [self sendServiceAVTransportWithData:xmlStr action:@"Pause"];
}

- (void)stop{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:Stop"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceAVTransport];
    [self sendServiceAVTransportWithData:xmlStr action:@"Stop"];
}

- (void)getPositionInfo{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:GetPositionInfo"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceAVTransport];
    [self sendServiceAVTransportWithData:xmlStr action:@"GetPositionInfo"];
}

- (void)getTransportInfo{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:GetTransportInfo"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceAVTransport];
    [self sendServiceAVTransportWithData:xmlStr action:@"GetTransportInfo"];
}

- (void)seekToTarget:(NSString *)target Unit:(NSString *)unit{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:Seek"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceAVTransport]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [command addChild:[GDataXMLElement elementWithName:@"Unit" stringValue:unit]];
    [command addChild:[GDataXMLElement elementWithName:@"Target" stringValue:target]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceAVTransport];
    [self sendServiceAVTransportWithData:xmlStr action:@"Seek"];
}


#pragma mark -
#pragma mark -- 构造RenderingControl动作XML --
- (void)getVolume{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:GetVolume"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceRenderingControl]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [command addChild:[GDataXMLElement elementWithName:@"Channel" stringValue:@"Master"]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceRenderingControl];
    [self sendServiceRenderingControlWithData:xmlStr action:@"GetVolume"];
}

- (void)setVolumeWith:(NSString *)value{
    GDataXMLElement *command = [GDataXMLElement elementWithName:@"u:SetVolume"];
    [command addChild:[GDataXMLElement attributeWithName:@"xmlns:u" stringValue:serviceRenderingControl]];
    [command addChild:[GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"]];
    [command addChild:[GDataXMLElement elementWithName:@"Channel" stringValue:@"Master"]];
    [command addChild:[GDataXMLElement elementWithName:@"DesiredVolume" stringValue:value]];
    NSString *xmlStr = [self prepareXMLFileWithCommand:command serviceType:serviceRenderingControl];
    [self sendServiceRenderingControlWithData:xmlStr action:@"SetVolume"];
}

#pragma mark -
#pragma mark -- 动作请求 --
- (void)sendServiceAVTransportWithData:(NSString *)xmlStr action:(NSString *)action{
    NSLog(@"xmlStr == %@", xmlStr);
    [self requestWithJudge:YES xmlStr:xmlStr action:action];
}

- (void)sendServiceRenderingControlWithData:(NSString *)xmlStr action:(NSString *)action{
    NSLog(@"xmlStr == %@", xmlStr);
    [self requestWithJudge:NO xmlStr:xmlStr action:action];
}

- (void)requestWithJudge:(BOOL)judge xmlStr:(NSString *)xmlStr action:(NSString *)action{
    NSString *SOAPAction;
    NSString *urlString;
    if (judge) {
        SOAPAction = [NSString stringWithFormat:@"\"%@#%@\"", serviceAVTransport,action];
        urlString = [self getUPnPURLWithUrlModel:_model.AVTransport urlHeader:_model.urlHeader];
    }else{
        SOAPAction = [NSString stringWithFormat:@"\"%@#%@\"", serviceRenderingControl,action];
        urlString = [self getUPnPURLWithUrlModel:_model.RenderingControl urlHeader:_model.urlHeader];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request addValue:SOAPAction forHTTPHeaderField:@"SOAPAction"];
    request.HTTPBody = [xmlStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || data == nil) {
            NSLog(@"%@", error);
            return;
        }else{
            [self parseRequestResponseData:data];
        }
    }];
    [dataTask resume];
}

- (NSString *)getUPnPURLWithUrlModel:(CLServiceModel *)model urlHeader:(NSString *)urlHeader{
    if ([[model.controlURL substringToIndex:1] isEqualToString:@"/"]) {
        return [NSString stringWithFormat:@"%@%@", urlHeader, model.controlURL];
    }else{
        return [NSString stringWithFormat:@"%@/%@", urlHeader, model.controlURL];
    }
}

#pragma mark -
#pragma mark -- 动作响应 --
- (void)parseRequestResponseData:(NSData *)data{
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *bigArray = [xmlEle children];
    NSLog(@"响应 == %@", xmlEle.XMLString);
    for (int i = 0; i < [bigArray count]; i++) {
        GDataXMLElement *element = [bigArray objectAtIndex:i];
        NSArray *needArr = [element children];
        if ([[element name] hasSuffix:@"Body"]) {
            [self resultsWith:needArr];
        }else{
            NSLog(@"未定义响应/Body错误");
        }
    }
}

- (void)resultsWith:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        GDataXMLElement *ele = [array objectAtIndex:i];
        if ([[ele name] hasSuffix:@"SetAVTransportURIResponse"]) {
            NSLog(@"设置URI成功");
            [self play];
            if (self.succeedBlock) {
                self.succeedBlock();
            }
        }else if ([[ele name] hasSuffix:@"GetPositionInfoResponse"]){
            NSLog(@"已获取进度, 协议回调可再进行解析使用");
            if ([self.delegate respondsToSelector:@selector(getPositionWithXMLElement:)]) {
                [self.delegate getPositionWithXMLElement:ele];
            }
        }else if ([[ele name] hasSuffix:@"GetTransportInfoResponse"]){
            NSLog(@"已获取状态, 协议回调可再进行解析使用");
            if ([self.delegate respondsToSelector:@selector(getTransportWithXMLElement:)]) {
                [self.delegate getTransportWithXMLElement:ele];
            }
        }else if ([[ele name] hasSuffix:@"PauseResponse"]){
            NSLog(@"暂停");
        }else if ([[ele name] hasSuffix:@"PlayResponse"]){
            NSLog(@"播放");
        }else if ([[ele name] hasSuffix:@"StopResponse"]){
            NSLog(@"停止");
        }else if ([[ele name] hasSuffix:@"SeekResponse"]){
            NSLog(@"跳转成功");
        }else if ([[ele name] hasSuffix:@"SetVolumeResponse"]){
            NSLog(@"声音设置成功");
        }else if ([[ele name] hasSuffix:@"GetVolumeResponse"]){
            NSLog(@"已获取音量信息, 协议回调可再进行解析使用");
            if ([self.delegate respondsToSelector:@selector(getVolumeWithXMLElement:)]) {
                [self.delegate getVolumeWithXMLElement:ele];
            }
        }else{
            NSLog(@"未定义响应/UPnP错误");
        }
    }
}

@end
