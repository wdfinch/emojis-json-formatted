require 'json'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/filters'


def get_formatted_categories(parsed_file)

  categories = []

  parsed_file.each do |i|
    formatted_hash = i.deep_symbolize_keys

    unless categories.find { |e| e[:group] == formatted_hash[:group] }
      categories.push({group: formatted_hash[:group], subgroups: []})
    end

    current_category_index = categories.index { |e| e[:group] == formatted_hash[:group] }

    unless categories[current_category_index][:subgroups].find { |e| e[:subgroup] == formatted_hash[:subgroup] }
      categories[current_category_index][:subgroups].push({subgroup: formatted_hash[:subgroup], emojis: []})
    end

    current_subcategory_index = categories[current_category_index][:subgroups].index { |e| e[:subgroup] == formatted_hash[:subgroup] }

    emojis = categories[current_category_index][:subgroups][current_subcategory_index][:emojis]

    emoji = {}
    emoji[:codes] = formatted_hash[:codes]
    emoji[:char] = formatted_hash[:char]
    emoji[:name] = formatted_hash[:name]
    emojis.push(emoji)
  end
  categories
end

def format_key(key)
  key.gsub! '&', 'and'
  key.gsub! "’", ''
  key.gsub!(/[^A-Za-z0-9\s]/i, ' ')
  key.downcase!
  key.squish!
  key.gsub!(" ", "_")
  key

end

def get_flat_emojis(categories)

  emojis_flat = {}

  categories.each do |c|
    c[:subgroups].each do |sg|
      sg[:emojis].each do |emoji|
        emojis_flat[emoji[:name]] = emoji[:char]
      end
    end
  end

  emojis_flat
end

def get_command_line_args
  options = {}

  ARGV.each do |cm|
    if cm == "-f" or cm == "--format"
      options[:format_emoji_name] = true
    end
  end

  options
end

def write_output_to_file(categories, flat_emojis)

  File.open("json/sorted_nested_emojis.json", "w") do |f|
    f.write(categories.to_json)
  end

  File.open("json/node_emoji_formatted_emojis.json", "w") do |f|
    f.write(flat_emojis.to_json)
  end
end

def format_categories(categories)
  categories.each do |c|
    c[:group] = format_key(c[:group])
    c[:subgroups].each do |sg|
      sg[:subgroup] = format_key(sg[:subgroup])
      sg[:emojis].each do |emoji|
        emoji[:name] = format_key(emoji[:name])
      end
    end
  end
  categories
end

def main

  options = get_command_line_args

  file = File.read('json/sorted_emojis.json')
  parsed_file = JSON.parse(file)

  categories = get_formatted_categories(parsed_file)
  categories = format_categories(categories) if options[:format_emoji_name]
  flat_emojis = get_flat_emojis(categories)

  write_output_to_file(categories, flat_emojis)
end

main