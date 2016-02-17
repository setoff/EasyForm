# EasyForm

[![CI Status](https://travis-ci.org/setoff/EasyForm.svg?style=flat)](https://travis-ci.org/setoff/EasyForm)
[![Version](https://img.shields.io/cocoapods/v/EasyForm.svg?style=flat)](http://cocoapods.org/pods/EasyForm)
[![License](https://img.shields.io/cocoapods/l/EasyForm.svg?style=flat)](http://cocoapods.org/pods/EasyForm)
[![Platform](https://img.shields.io/cocoapods/p/EasyForm.svg?style=flat)](http://cocoapods.org/pods/EasyForm)

This is `UITableViewDataSource/UITableViewDelegate` form constructor solution. It allows to use `UITableView/UITableViewCell` customization abilities. We provide several basic  [Cells](https://github.com/setoff/EasyForm/tree/master/EasyForm/Cells). If you haven't found any particular form UI element you can easily create it by yourself with familiar tools like InterfaceBuilder (using cell xibs) or by subclassing `UITableViewCell`. And pull-requests are welcome!

Form configuration and logic can be implemented in declarative way. Can be placed in separate module and reused in different view controllers.

## Try

You have two options to try lib:
```sh
$ git clone git@github.com:setoff/EasyForm.git
$ cd EasyForm/Example
$ pod install
$ open EasyForm.xcworkspace
```
or

```sh
$ pod try EasyForm
```
After workspace has been opened select `EasyForm-Example` target and run app.

## Usage

`EFForm` implements `UITableViewDelegate` and `UITableViewDataSource` protocols. So you can easily use form with any instance of `UITableView`. But it is recommended to use with `UITableViewController` (or subclasses) because of several ‘free’ features like scrolling to focused text field which placed in `UITableViewCell`.

Form implementation structure looks like this:
```Objective-C
self.form = [EFForm new];

// Config form items
EFElement *input = [[EFElement alloc] initWithTag:@"inputField"
                                        cellClass:[EFTextFieldCell class]];
input.setupCell = ^(UITableViewCell *cell) {
    ((EFTextFieldCell *)cell).textField.placeholder = @"Tap to start typing";
};

EFElement *switchElement = [[EFElement alloc] initWithTag:@"switch"
                                                cellClass:[EFSwitchCell class]];
switchElement.setupCell = ^(UITableViewCell *cell) {
    ((EFSwitchCell *)cell).titleLabel.text = @"Cell with switch";
    ((EFSwitchCell *)cell).switchToggle.onTintColor = [EFExampleHelpers greenColor];
    ((EFSwitchCell *)cell).onToggle = ^(BOOL isOn) {
        [self.presentingController alertAction:[NSString stringWithFormat:@"Toggle is %@",
                                                isOn ? @"ON" : @"OFF"]];
    };
};


// Config section and add form elements
EFSection *inputSection = [[EFSection alloc] initWithTag:@"predefined"
                                              elements:@[input, switchElement]];
inputSection.title = @"Form section";

// Add sections to form
self.form.sections = @[inputSection];
[self.tableView displayForm:self.form];
```

## Installation

EasyForm is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your `Podfile`:

```ruby
pod "EasyForm"
```

## License

EasyForm is available under the MIT license. See the LICENSE file for more info.
