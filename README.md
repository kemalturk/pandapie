![Pub](https://img.shields.io/pub/v/pandapie) 


# PandaBar

A fancy pie chart for pandas. Pandapie designed for new neumorphic design trend.

| Preview | PageView |
|---------|----------|
|![Preview Png](preview.png "Preview") | ![Preview Gif](preview.gif "PageView") |

### PandaPie
- `size` - size of chart
- `selectedKey` - selected key

### PandaPieData
- `id` - the id of this item
- `value` - the value of this item

## Getting Started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  pandapie: ^0.1.0
```

## Basic Usage

```dart
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202327),
      body: Center(
        child: PandaPie(
          selectedKey: '3',
          data: [
            PandaPieData(
              key: '1',
              value: 50,
            ),
            PandaPieData(
              key: '2',
              value: 50,
            ),
            PandaPieData(
              key: '3',
              value: 30,
            ),
          ],
        ),
      ),
    );
  }
}
```
