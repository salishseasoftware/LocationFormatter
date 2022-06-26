# ``LocationFormatter/CoordinateFormat/degreesMinutesSeconds``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Examples

```
48° 6' 59" N, 122° 46' 31" W

48° 6' 59", -122° 46' 31"

48 6 59 N, -122 46 31
```

### Components

| Orientation | Degrees | Minutes | Seconds | Direction |
| ----------  | ------- | ------- | ------- | --------- |
| Latitude    | 48      | 6       | 59      | North     |
| Longitude   | 122     | 46      | 31      | West      |

> Tip: There are 60 minutes in a degree, and 60 seconds in a minute.

## See Also

- ``LocationFormatter/CoordinateFormat/decimalDegrees``
- ``LocationFormatter/CoordinateFormat/degreesDecimalMinutes``
- ``LocationFormatter/CoordinateFormat/utm``
- ``LocationFormatter/DisplayOptions``
- ``LocationFormatter/SymbolStyle``
