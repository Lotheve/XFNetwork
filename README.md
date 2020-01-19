# 设计一个离散型API的网络框架

## 基本面分析

> 为什么设计一个离散型API的网络框架？

从API的调用方式入手，分为集约型API和离散型API。集约型API提供一个或若干个统一接口，业务方通过该接口统一传递参数、请求方式、回调句柄等。离散型API设计下，业务方每个接口对应一个独立的请求实体，该实体是对下层请求的抽象，通过对该实体自定义相关请求参数，例如加解密方式、请求参数编码类型、请求超时时长等来达到接口可配置化的效果。

集约型API的好处是调用简单，适用于接口格式统一的场景，难于拓展。而离散型API则适用于各种场景，由于各个请求都可单独配置请求参数，使用上会非常灵活。对于业务层来说，离散型API毫无疑问具备更高的可定制性和可拓展性的。因为接口调用的粒度细化到单个请求，也就方便对于单个请求进行配置及一些操作，例如手动控制请求的起飞降落、对单个请求相关方法进行AOP等等。不过也正因为离散型API的灵活性，业务方使用时会相对繁琐（灵活与复杂往往是并存的）。另外当应用较为庞大时，大量的API类会共存，后期存在一定的维护成本。

事实上，不管面向业务这一层的API是集约型还是离散型的，网络框架底层必定是有集约的一层的。这就好比一个洒水壶，不管我用哪种方式往里面灌水，最终水都是从同一个花洒出去的。不过对于业务方来说，事实上接水的方式可能五花八门，姿势各不相同，离散型API则能比较好地契合这个需求。AFN3.0就是一个集约型API的框架，通过统一接口调用，使用简单。在设计时我们可以直接在这些集约型的网络框架上再封装一层离散型的API，不过为了更好地定制功能，我会在AFN3.0的基础上，再封装一层集约型的网络分发层，再上面一层才是面向业务的离散型API。

另外，设计一个离散型API的基础网络框架对于业务方而言，调用将会非常灵活。对于业务简单的应用，可在上层再封装一层集约型接口，以减少调用成本；对于业务复杂、服务器环境多样化、体量较大的应用，业务方可就地按照离散型API接口进行调用，维护好各个请求实体类即可。因此基础层使用离散型API的设计，也是满足了对于不同场景的需求。

## 基本问题分析

> 数据交付方式使用delegate交付还是block交付？

对于集约型的API，数据只能采用block的方式交付。试想通过delegate的方式交付数据，由于请求入口是相同的，业务方在调用统一API时需要向内部传入一个回调对象，例如下面这样：

```objc
[RequestAPI sendRequestWithAction:action Params:params callBackDelegate:self];
```

这还不够，如此虽然请求落地时能回调出来了，但是没法区分具体是哪个请求。因此业务方还需要保存具体请求的标识，这显然不符合集约型API的设计规范。AFNetworking作为一个集约型API的框架，也是使用block作为数据交付方式的。

而离散型API的数据方式，我认为使用block还是delegate交付数据都可以。系统的NSURLSession作为离散型API的框架，是采用delegate作为回调方式的。不过我更倾向于block方式，因为代码聚合度更好，这样业务方的代码逻辑清晰。如果采用delegate方式，还需要在回调方法里判断请求实体对象再执行相应逻辑，代码较为松散。

> 如何支持多服务模式？

一个应用中，接入的服务往往不是单一的，除了常规的业务服务，可能还要接认证中心、埋点系统、客服系统等。这些不同的服务，往往会架在不同的机器上，对外的ip是不同的。因此在设计基础网络框架时，需要考虑业务方如何接入不同的服务。这里主要考虑两点：

1. 不同服务的访问地址不同
2. 具体请求中，相关配置是以服务为粒度的。例如一个服务的https证书校验方式、支持的请求最大并发数等，这些配置往往不是以单个请求为粒度的，而是应当针对一个服务进行统一配置。这里想提一句的是，HTTP2.0支持TCP管道的多路复用（iOS中9.0之后开始支持），多个请求可以同时在一个管道中通信。对于频繁交互的服务，配置该服务时适当调高"相同目标主机最大并发数"，能够有效提升请求效率。

基于该问题的分析，在设计时应当设计Service接口表示服务实体，让业务方去定义具体的实现。在调用时，业务方应当为一个请求指定其从属的服务。

> 如何保证相关功能可定制化？

业务方使用一个网络框架，必然会考量这个框架的弹性如何，是否支持自己的功能，或者是否支持自身功能的拓展。这些功能包括但不限于：加解密方式、JSON解析方式、数据转换方式、错误处理方式等。作为框架提供方，是无法事先预知业务方会采用哪种策略方案的，更不应该为业务方选定一种默认方案(这将严重局限一个框架的功能)，而应当开放相关的插槽（Slot），供业务方提供策略。

具体实现时，针对提到的这些问题，可以选择性地使用策略模式或者切面等方式提供可定制性。

## 功能构想

> 需要解决哪些问题，或者支持哪些功能？

以下是对于一个离散型网络框架的基本功能设计构想：

1. 支持常规数据请求、下载请求、上传请求 
2. 支持常规请求方式
3. 支持批量请求 
4. 开放单个请求的手动降落(取消请求)
5. 支持自定义数据转换方式
6. 支持自定义参数加解密方式
7. 面向多服务设计，隔离各个服务配置

## 结构设计

经过分析后框架整体结构设计如下：

![未XFNetwork](http://lotheve.cn/blog/XFNetwork/XFNetwork.png)

整体从上往下是一个先离散，后集约的结构。

- API：代表请求实体，业务方只需要操作API对象即可控制请求的起飞和降落。具体区分DataAPI（常规数据请求）、DownloadAPI（下载请求）、UploadAPI（上传请求）、BatchAPI（批量请求）。
- Service：为API提供服务隔离服务。
- Reformer：为API提供交付数据自定义服务。
- Encryptor：为API提供参数加解密服务。
- APIChannel：API的整合通道，根据API信息建立底部请求，根据服务配置信息创建AF层的manager，通过manager发起请求。因为是多服务设计，Client与Service将是一对一的关系，Service根据需要提供配置信息。

## 关键类说明

### XFAPI

> 收集单个请求粒度的请求配置信息，包括请求方式、请求头、超时时长、reformer、service、encryptor、单个请求回调句柄等，同时提供请求起飞落地的接口。

```objc
@interface XFAPI : NSObject
//...
@property (nonatomic, strong) XFEncryptor<XFEncryptorProtocol> *encryptor;
@property (nonatomic, strong) XFReformer<XFReformerProtocol> *reformer;
@property (nonatomic, copy) XFAPISuccessBlock successBlock;
@property (nonatomic, copy) XFAPIFailBlock failBlock;
@property (nonatomic, copy) XFAPIProgressBlock uploadProgressBlock;
@property (nonatomic, copy) XFAPIProgressBlock downloadProgressBlock;
- (void)start;
- (void)cancel;
@end
```

该类提供了API的通用配置，具体业务方使用时，应当根据请求类型实例化具体子类。

### XFService

> 业务方通过该类自定义服务配置，创建时需要继承`XFService`，同时遵守`XFServiceProtocol`，提供两个信息：服务基址、服务配置。创建API时，通常需要为API指定服务，此处采用了策略模式来保证灵活性。

```objc
@protocol XFServiceProtocol <NSObject>
+ (nonnull NSString *)serviceURL;
@optional
+ (nonnull XFAPIChannelConfig *)sessionClientConfiguration;
@end
```

### XFReformer

> 响应数据是业务的，作为框架无法限定数据格式，也无法限定数据转换的方式，这些事情应该交由业务来做。例如不同接口，响应的原始数据JSON格式是不同的，亦或是业务方需要API直接交付某种类型的数据，这就需要业务方自己为API提供数据转换的方式。在使用时，创建`XFReformer`的子类，同时遵守`XFReformerProtocol`，提供具体的数据转换策略。

```objc
@protocol XFReformerProtocol <NSObject>
- (id)reformResponseObject:(id)responseObj forAPI:(XFAPI *)API withError:(NSError **)error;
@end
```

### XFEncryptor

> 数据传输过程中，往往需要对参数进行加解密，同样不同业务加解密方式也无法限定。通过提供该策略入口，供业务方提供参数加解密方式。使用时创建`XFEncryptor`的子类，同时遵守`XFEncryptorProtocol`，提供加解密策略。

```objc
@protocol XFEncryptorProtocol <NSObject>
- (id)encrypt:(id)clearData;
- (id)decrypt:(id)cipherData;
@end
```

### XFAPIChannel

> 为离散API提供集约请求的能力，所有API都将通过Channel来发起请求。Channel是内部根据业务方提供的Service自动创建的，一个Channel对应一个底层的AFSessionManager，这么做的目的就是为了支持以服务为粒度的请求配置，这么做是必要的，具体在*\*如何支持多服务模式\**有过分析。

```objc
+ (XFAPIChannel *)channelForAPI:(XFAPI *)API
{
    Class serviceCls = [API.service class];
    if (!serviceCls || !NSStringFromClass(serviceCls)) {
        return _apiChannels[kDefaultAPIChannel];
    }
    NSString * serviceKey = NSStringFromClass(serviceCls);
    if (_apiChannels[serviceKey]) {
        return _apiChannels[serviceKey];
    }
    @synchronized (_apiChannels) {
        XFAPIChannel *apiChannel = [serviceCls respondsToSelector:@selector(apiChannelConfiguration)] ? [XFAPIChannel channelWithConfiguration:[serviceCls apiChannelConfiguration]] : [XFAPIChannel channel];
        _apiChannels[serviceKey] = apiChannel;
        return apiChannel;
    }
    return _apiChannels[kDefaultAPIChannel];
}
```

以上代码为内部根据API的service自动创建或获取Channel的方式，具体的配置信息是有service对象提供的。

## 使用示例

业务方根据需要创建API示例，并设置相关的API参数。以下为一个常规请求的示例：

```objc
_dataAPI = [[XFDataAPI alloc] init];
//请求方式
_dataAPI.method = APIMethodGet;
//超时时长
_dataAPI.timeoutInterval = 10;
//参数
_dataAPI.params = @{@"code":@"utf-8",@"q":@"卫衣"};
//指定service
_dataAPI.service = [XFServiceManager serviceForClass:[TBService class] withSubPath:@"sug"];	
//指定reformer
_dataAPI.reformer = [TBReformer new];	
//成功回调句柄
_dataAPI.successBlock = ^(id object, XFAPI *API, NSURLResponse *response) {
    //TODO
};
//失败回调句柄
_dataAPI.failBlock = ^(id object, NSError *error, XFAPI *API, NSURLResponse *response) {
	//TODO
};
//发起请求
[_dataAPI start];
```

TBService定义如下，仅提供了必需的`serviceURL`：

```objc
@interface TBService : XFService<XFServiceProtocol>
@end

@implementation TBService
+ (NSString *)serviceURL
{
    return @"https://suggest.taobao.com/";
}
@end
```

TBReformer定义如下，提供了业务需要的数据转换方式：

```objc
@interface TBReformer : XFReformer<XFReformerProtocol>
@end

@implementation TBReformer
- (id)reformResponseObject:(id)responseObj forAPI:(XFAPI *)API withError:(NSError **)error
{
    if (!responseObj) {
        *error = [NSError errorWithDomain:@"RequestError" code:1 userInfo:@{NSLocalizedDescriptionKey:@"数据为空!"}];
        return nil;
    }
    if ([responseObj isKindOfClass:[NSData class]]) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:error];
        return jsonObj;
    }
    return responseObj;
}
@end
```