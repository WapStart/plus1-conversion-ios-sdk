Plus1 WapStart Conversion iOS SDK
=================================

Это open source библиотека для интеграции механизма подсчета конверсии в сети [Plus1 WapStart](https://plus1.wapstart.ru) в ваши iOS-приложения, включая iPhone и iPad.

Библиотека распространяется под свободной лицензией BSD (as is).

# Установка и настройка

1. Скачайте последнюю версию SDK: https://github.com/WapStart/plus1-conversion-ios-sdk/tags
2. Добавьте все файлы, находящиеся в директории _sdk_, в свой проект;
3. В prefix header файле *(.pch)* своего приложения укажите константы, необходимые для работы SDK. Например:
    
    \#define Plus1TrackId @"afd123djdgf623gjahsdfjdygf2634ysduyfg3" // Идентификатор счетчика в системе Plus1 WapStart  
    

Для корректной работы тестового приложения [HelloConversion](https://github.com/WapStart/plus1-conversion-ios-sdk/blob/master/examples/HelloConversion/) также требуется указать id счетчика *(Plus1TrackId)* в файле [HelloConversion-Prefix.pch](https://github.com/WapStart/plus1-conversion-ios-sdk/blob/master/examples/HelloConversion/HelloConversion/HelloConversion-Prefix.pch).

Идентификатор счетчика можно узнать на странице **Конверсия**.

# Использование SDK

Рассмотрим настройку приложения для подсчета конверсий на примере [HelloConversion](https://github.com/WapStart/plus1-conversion-ios-sdk/blob/master/examples/HelloConversion/)

В первую очередь необходимо добавить собственную url-схему. Это необходимо для возврата из браузера обратно в приложение после учета целевого действия. Схему нужно добавить в plist вашего приложения.

![Info.plist](https://github.com/WapStart/plus1-conversion-ios-sdk/raw/master/doc/scheme.plist.png)

Для тестового приложения в качестве схемы выступает wsp1hc://

**Внимание:** для гарантии возврата в ваше приложение - схема должна быть уникальна. Если указанная вами схема используется другим приложением, поведение iOS не регламентированно и переход по ссылке может быть осуществлен в любое приложение. Постарайтесь придумать достаточно уникальную схему.

После того, как вы придумали схему, необходимо инициализировать счетчик конверсий. Инициализируется он двумя параметрами: id счетчика и ссылкой для возврата в приложение. Пример:

```ObjectiveC
    Plus1ConversionTracker *tracker = [[Plus1ConversionTracker alloc] initWithTrackId:Plus1TrackId andCallbackUrl:@"wsp1hc://ru.wapstart.plus1.conversion.hello"];
    [tracker run];
    [tracker release];
```

При первом запуске приложения счетчик сработает, в браузере откроется специально сформированная ссылка, откуда пользователя перенаправит обратно в приложение по указанной вами ссылке. Вышесказанное верно в случае наличия интернет-подключения. В противном случае браузер открыт не будет и подсчет целевого действия будет отложен до следующего раза.

# Контактная информация
По всем возникающим у вас вопросам интеграции вы можете обратиться в службу поддержки пользователей:  
E-Mail: clientsupport@co.wapstart.ru  
ICQ: 553425962
