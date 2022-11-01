enum TracerouteEnum {
  start,
  router,
  routerDoesNotRespond,
  finished,
  failed,
  undefined,
}

abstract class TraceRouteEnumParser {
  static TracerouteEnum parseValue(String value) {
    switch (value) {
      case 'start':
        return TracerouteEnum.start;
      case 'router':
        return TracerouteEnum.router;
      case 'routerDoesNotRespond':
        return TracerouteEnum.routerDoesNotRespond;
      case 'finished':
        return TracerouteEnum.finished;
      case 'failed':
        return TracerouteEnum.failed;
    }

    return TracerouteEnum.undefined;
  }

  static String parseEnum(TracerouteEnum value) {
    switch (value) {
      case TracerouteEnum.start:
        return 'start';
      case TracerouteEnum.router:
        return 'router';
      case TracerouteEnum.routerDoesNotRespond:
        return 'routerDoesNotRespond';
      case TracerouteEnum.finished:
        return 'finished';
      case TracerouteEnum.failed:
        return 'failed';
      default:
        return '';
    }
  }
}
