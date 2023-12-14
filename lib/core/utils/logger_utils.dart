import 'package:logger/logger.dart';

var logger = Logger(
    filter: null,
    printer: PrettyPrinter(
        // Number of method calls to be displayed
        methodCount: 2,
        // Number of method calls if stacktrace is provided
        errorMethodCount: 8,
        // Width of the output
        lineLength: 120,
        // Colorful log messages
        colors: true,
        // Print an emoji for each log message
        printEmojis: true,
        // Should each log print contain a timestamp
        printTime: false),
    output: null);
