---
title: JSON Schema
date: 2016-12-04T13:30:00+10:00
author: Martin Brennan
layout: post
permalink: /json-schema/
---

When writing a common data transfer format, you will need a strong schema or specification so each client that uses that format knows how to parse, validate, and construct data using it. In XML you can use [XSD](https://en.wikipedia.org/wiki/XML_Schema_(W3C)), which is used to specify validation rules and elements expected in an XML file, as well as specifying the type of data expected (strings, integers, dates etc.). When using JSON, the best way to achieve this is with [JSON Schema](http://json-schema.org/), and I'll give a quick run through of how to use it and the things you can do with it in this article.

<!--more-->

First of all we will start with the structure of the data we are expecting via JSON. We have numbers, strings, datetimes, and even complex objects.

```json
{
  "id": 1,
  "firstName": "James",
  "lastName": "Hickock",
  "dob": "1837-05-27T00:00:00Z",
  "pistols": [{
    "make": "Colt",
    "model": "1851 Navy",
    "caliber": 0.36
  }, {
    "make": "Smith & Wesson",
    "model": "Model 2 Army",
    "caliber": 0.32
  }]
}
```

To begin, we need to define the most basic properties of the schema, which itself is in JSON format. We will define the `$schema`, which is like the schema definition in an XSD file. We define a basic title and description for the schema and the `type` which is like a language type.

```json
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "Old West Folk Heroes",
  "description": "A hero of the Old West",
  "type": "object"
}
```

From here, we want to make sure that the `id`, `firstName`, `lastName`, and `dob` are all filled in and the correct type. We use the `properties` key for this in the JSON schema. We also want to make all of the fields `required`. Note that the `description` for each property is optional. Add this onto the above JSON.

```json
{
  "properties": {
    "id": {
      "type": "integer"
    },
    "firstName": {
      "description": "The first name of the hero",
      "type": "string"
    },
    "lastName": {
      "description": "The last name of the hero",
      "type": "string"
    },
    "dob": {
      "description": "The estimated date of birth",
      "type": "string",
      "format": "date-time"
    },
    "pistols": {
      "type": "array",
      "description": "A list of pistols the gunslinger was known to use"
    }
  },
  "required": ["id", "firstName", "lastName", "dob"]
}
```

## Complex Objects (Sub-Schema)

Say we wanted to make a sub-schema for the `pistols` array. Every pistol needs a make, model, and caliber. We can do this by defining another schema in the same file, and referencing it with the `items` property for the `array`. We will change it to look like this:

```json
{
  "pistols": {
    "type": "array",
    "description": "A list of pistols the gunslinger was known to use",
    "items": {
      "$ref": "#/definitions/pistol"
    }
  }
}
```

You can then make a `definitions` property in the main schema to hold all of the sub-schemas. It doesn't _have_ to be called `definitions`, it's just an easy way to keep all of these references grouped together. You can use the same rules as your main schema for your sub-schema:

```json
{
  "definitions": {
    "pistol": {
      "properties": {
        "make": {
          "type": "string"
        },
        "model": {
          "type": "string"
        },
        "caliber": {
          "type": "number",
          "minimum": 0,
          "maximum": 1,
          "exclusiveMinimum": true
        }
      }
    }
  }
}
```

I had some trouble with these rerences at first, until I realize I had misspelled the `$ref` path. Watch your spelling and case! (as always in programming, duh)

## Validation Libraries

From here, you will want a way to validate your **actual** JSON data against your schema. There is a library to do this in pretty much every language, here are some of the more popular ones:

- **C#** - [http://www.newtonsoft.com/jsonschema](http://www.newtonsoft.com/jsonschema)
- **JavaScript** - [http://geraintluff.github.io/tv4/](http://geraintluff.github.io/tv4/)
- **Ruby** - [https://github.com/ruby-json-schema/json-schema](https://github.com/ruby-json-schema/json-schema)
- **Python** - [https://pypi.python.org/pypi/jsonschema](https://pypi.python.org/pypi/jsonschema)
- **Java** - [https://github.com/daveclayton/json-schema-validator](https://github.com/daveclayton/json-schema-validator)
- **Golang** - [https://github.com/xeipuuv/gojsonschema ](https://github.com/xeipuuv/gojsonschema)
- **PHP** - [https://github.com/justinrainbow/json-schema ](https://github.com/justinrainbow/json-schema)

For reference, here is an example implementation I wrote to run JSON validation against a schema using node.js, as a static tester for an established schema:

```javascript
var validator = require('is-my-json-valid/require'),
    fs        = require('fs'),
    tv4       = require('tv4'),
    argv      = require('yargs'),
    formats   = require('tv4-formats');

// load the json data to test against
var dataPath = argv.datafile || 'datafile.json';
var data     = JSON.parse(fs.readFileSync(dataPath).toString());
var schema   = JSON.parse(fs.readFileSync('schema.json').toString());

// important - this must be done otherwise the format validations are ignored
tv4.addFormat(formats);

// validate the schema against the data and log the results
var isValid = tv4.validate(data, schema);
if (!isValid) {
  console.log('ERROR validating ' + dataPath + ' against schema.');
  console.log('--------------------------------------------------------\n');
  console.log(parseError(tv4.error));
} else {
  console.log('SUCCESS validating ' + dataPath + ' against schema.');
}

/**
 * Build up the T4 error message for logging to the console,
 * going through each of the sub-errors which are to do with
 * validation.
 *
 * @param {Object} error The t4 error object from parsing the schema.
 */
function parseError(error) {
  var message = error.message + ' (' + error.schemaPath + ')';

  if (error.subErrors !== null) {
    for (var i = 0; i < error.subErrors.length; i++) {
      var err = error.subErrors[i];
      message += '\n\t' + parseError(err);
    }
  }

  return message;
}
```

## References

The JSON schema documentation is quite extensive and contains both [basic](http://json-schema.org/example1.html) and [advanced](http://json-schema.org/example2.html) examples. There is alos the following main documentation:

- [JSON Schema Core Documentation](http://json-schema.org/latest/json-schema-core.html)
- [JSON Schema Validation Documentation](http://json-schema.org/latest/json-schema-validation.html)

I really reccomend that you go and read over these, because there are _a lot_ of different validations you can perform on your JSON schema. There is also a great resource out there called [Understanding JSON Schema](https://spacetelescope.github.io/understanding-json-schema/index.html) that is useful in explaining areas where the documentation is a bit light.