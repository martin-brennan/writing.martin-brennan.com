---
title: Why xUnit?
date: 2016-10-02T22:00:00+10:00
author: Martin Brennan
layout: post
permalink: /why-xunit/
---

I was fairly recently introduced to [XUnit](https://xunit.github.io/) by a work colleague, and I now prefer it over the default Microsoft Unit Test project format. In fact, I feel kinda dumb for having used the default for so many years when there are so many alternatives, like xUnit, [NUnit](http://www.nunit.org/), and [Moq](https://github.com/Moq/moq4). Granted I haven't tried to use the other two, I thought I'd write about what I like about xUnit over the default MSTest framework.<!--more-->

## Getting started

To use xUnit in your project, and be able to run tests using the Visual Studio test runner, you need only create a Class Library project. Then, use NuGet to install both xUnit and the Visual Studio runner:

```
Install-Package xunit
Install-Package xunit.runner.visualstudio
```

You can also head over to the [xUnit Getting Started](https://xunit.github.io/docs/getting-started-desktop.html) page to learn more.

## The best parts

### Error Assertion

One of the main features I found missing with MSTest is that you cannot easily `Assert` that an `Exception` of a certain type with a certain message has been returned. With xUnit, you can not only assert an exception type, but collect the exception too and assert the message. Here is an example. Say I have the following method that checks the provided number is less than 21, throwing an `ArgumentException` if it is:

```csharp
public bool CanEnterBar(int age) {
  if (age < 21) {
    throw new ArgumentException("Get outta here kid!");
  }

  return true;
}
```

And the assertion using xUnit:

```csharp
[Fact]
public void CanEnterBar_Should_ThrowExceptionIfNot21() {
  Exception ex = Assert.Throws<ArgumentException>(() => {
    CanEnterBar(15);
  });

  Assert.Equal("Get outta here kid!", ex.Message);
}
```

### Facts and Theories

Tests in xUnit are split up into Facts and Theories, both specified using an [Attribute](https://msdn.microsoft.com/en-us/library/mt653979.aspx). A Fact is a regular test, like using the `[Test]` attribute in MSTest, and it should be used when you expect the same result from the test no matter the input.

The `[Theory]` attribute is used to mark a test as data-driven, which you can provide with parameters on each run. This is great for when you want to test the same method with many different inputs to confirm that it holds up. You use the `[InlineData]` attribute with a Theory to send it data.For example, let's see the same test as a Theory.

```csharp
[Theory]
[InlineData(18)]
[InlineData(10)]
[InlineData(-24568)]
public void CanEnterBar_Should_ThrowExceptionIfNot21(int testAge) {
  Exception ex = Assert.Throws<ArgumentException>(() => {
    CanEnterBar(testAge);
  });

  Assert.Equal("Get outta here kid!", ex.Message);
}
```

The test will appear many different times in the Test Explorer, running once for each `InlineData` attribute specified.

### Exception stack traces

I'm not sure about everyone else, but I always found the stack traces created by MSTest to be very lacklustre. It was often difficult to get to the root cause of the test, or even the actual line number of the code that broke rather than the line number of the breaking test. The stack traces created by xUnit in Visual Studio are much nicer.

### Other benefits

Finally, here are several dot point benefits of xUnit over MSTest, drawn from various sources:

- The `[Fact]` and `[Theory]` attributes are extensible, so you can implement your own testing functionality.
- xUnit doesn't use Test Lists and .vsmdi files to keep track of your tests.
- MSTest copies your files to a test directory, which eats un HDD space and sometimes causes cached test results or files interfering with the tests.
- MSTest doesn't have parameterized tests, but xUnit does via Theory.
- There is no `[Setup]` and `[Teardown]` attributes, this is done using the test class' constructor and an `IDisposable`.
- Microsoft is using xUnit a lot now internally, because it is better and one of its creators is from Microsoft.

And here are some articles about why xUnit is better, and MSTest is bad (some of these are quite old but their points are still valid):

- [https://www.richard-banks.org/2010/03/mstest-sucks-for-unit-tests.html](https://www.richard-banks.org/2010/03/mstest-sucks-for-unit-tests.html)
- [http://blog.ploeh.dk/2010/04/26/WhyImmigratingfromMSTesttoxUnit.net/](http://blog.ploeh.dk/2010/04/26/WhyImmigratingfromMSTesttoxUnit.net/)
- [http://georgemauer.net/2015/05/01/why-not-mstest](http://georgemauer.net/2015/05/01/why-not-mstest)
- [http://seankilleen.com/2015/06/xUnit-vs-MSTest/](http://seankilleen.com/2015/06/xUnit-vs-MSTest/)
- [http://stackoverflow.com/questions/261139/nunit-vs-mbunit-vs-mstest-vs-xunit-net/](http://stackoverflow.com/questions/261139/nunit-vs-mbunit-vs-mstest-vs-xunit-net)

## Conclusion

Now, every C# project I start uses xUnit for the testing framework and I couldn't be happier with it. It really is a lightweight and great framework, and I recommend you check it out.
