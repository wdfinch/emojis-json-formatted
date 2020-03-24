# emojis-json-formatted

Provides formatted emoji json files in two formats:

1. **Sorted Nested** - Nested format organized by group and sub-group
3. **Single Object** - One object with the key as the emoji name and the value as the emoji character value

Usage
------

To build the json files, simply run:

```
bundle install
ruby build.rb
```

By default this will use the original naming as indiciated in sorted_emojis.json. For formatted key/value naming, please use the -f or --format flag on the command above.

*Note formatted json files have already been generated and can be found in the json folder.*

Lastly please note that sorted_emojis.json is the starting file for generating the other formats and must be kept in the json folder. Credit to [amio/emoji.json](https://github.com/amio/emoji.json) for this file.
