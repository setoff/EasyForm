# EasyForm

[![CI Status](http://img.shields.io/travis/Ilya Sedov/EasyForm.svg?style=flat)](https://travis-ci.org/Ilya Sedov/EasyForm)
[![Version](https://img.shields.io/cocoapods/v/EasyForm.svg?style=flat)](http://cocoapods.org/pods/EasyForm)
[![License](https://img.shields.io/cocoapods/l/EasyForm.svg?style=flat)](http://cocoapods.org/pods/EasyForm)
[![Platform](https://img.shields.io/cocoapods/p/EasyForm.svg?style=flat)](http://cocoapods.org/pods/EasyForm)

This libs is not pretended as non-UITableview-solution. It allows us to use all `UITableView/UITableViewCell` customization abilities. If we haven't found any particular form UI element(see Cells subspec) you can easily create it by yourself with familiar tools like InterfaceBuilder (using cell xibs) or by subclassing `UITableViewCell`.

Form configuration and logic can be implemented in declarative way. Can be placed in separate module and reused in different view controllers.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

`EFForm` class implements `UITableViewDelegate` and `UITableViewDataSource` protocols. So you can easily use form with any instance of `UITableView`. But it is recommended to use it with `UITableViewController` (or subclasses) because of several ‘free’ features like scroll to focused text field which placed in `UITableViewCell`.

```Objective-C
self.form = [EFForm new];

// Config form items
EFElement *input = [[EFElement alloc] initWithTag:@"inputField"
                                        cellClass:[EFTextFieldCell class]];
input.setupCell = ^(UITableViewCell *cell) {
    ((EFTextFieldCell *)cell).textField.placeholder = @"Tap to start typing";
};

// Config section and add form elements
EFSection *inputSection = [[EFSection alloc] initWithTag:@"predefined"
                                              elements:@[input]];
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

## Author

Ilya Sedov, i.setoff@gmail.com

## License

EasyForm is available under the MIT license. See the LICENSE file for more info.
