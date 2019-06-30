# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_29_125715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "ancestors", force: :cascade do |t|
    t.integer "wof_id", null: false
    t.integer "ancestor_wof_id", null: false
    t.string "ancestor_placetype", null: false
    t.integer "lastmodified", null: false
    t.index ["ancestor_wof_id", "ancestor_placetype", "lastmodified"], name: "ancestors_by_ancestor"
    t.index ["lastmodified"], name: "ancestors_by_lastmod"
    t.index ["wof_id", "ancestor_placetype", "lastmodified"], name: "ancestors_by_wof_id"
    t.index ["wof_id"], name: "index_ancestors_on_wof_id"
  end

  create_table "concordances", force: :cascade do |t|
    t.integer "wof_id", null: false
    t.decimal "other_id", precision: 40
    t.string "other_source"
    t.integer "lastmodified"
    t.index ["lastmodified"], name: "concordances_by_lastmod"
    t.index ["other_source", "other_id", "lastmodified"], name: "concordances_by_other_lastmod"
    t.index ["other_source", "other_id"], name: "concordances_by_other_id"
    t.index ["wof_id", "lastmodified"], name: "concordances_by_wof_id"
    t.index ["wof_id"], name: "index_concordances_on_wof_id"
  end

  create_table "geojson", force: :cascade do |t|
    t.integer "wof_id", null: false
    t.jsonb "body"
    t.integer "lastmodified", null: false
    t.index ["lastmodified"], name: "geojson_by_lastmod"
    t.index ["wof_id"], name: "index_geojson_on_wof_id"
  end

  create_table "names", force: :cascade do |t|
    t.integer "wof_id", null: false
    t.string "placetype"
    t.string "country"
    t.string "language"
    t.string "extlang"
    t.string "script"
    t.string "region"
    t.string "variant"
    t.string "extension"
    t.string "privateuse"
    t.string "name"
    t.integer "lastmodified", null: false
    t.index ["country", "privateuse", "placetype"], name: "names_by_country"
    t.index ["language", "privateuse", "placetype"], name: "names_by_language"
    t.index ["lastmodified"], name: "names_by_lastmod"
    t.index ["name", "placetype", "country"], name: "names_by_name"
    t.index ["name", "privateuse", "placetype", "country"], name: "names_by_name_private"
    t.index ["placetype", "country", "privateuse"], name: "names_by_placetype"
    t.index ["wof_id"], name: "names_by_wofid"
  end

  create_table "spr", force: :cascade do |t|
    t.integer "wof_id", null: false
    t.integer "parent_id"
    t.string "name"
    t.string "placetype"
    t.string "country"
    t.string "repo"
    t.decimal "latitude", precision: 10, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.decimal "min_latitude", precision: 10, scale: 7, null: false
    t.decimal "min_longitude", precision: 10, scale: 7, null: false
    t.decimal "max_latitude", precision: 10, scale: 7, null: false
    t.decimal "max_longitude", precision: 10, scale: 7, null: false
    t.integer "is_current"
    t.integer "is_deprecated"
    t.integer "is_ceased"
    t.integer "is_superseded"
    t.integer "is_superseding"
    t.string "superseded_by"
    t.string "supersedes"
    t.integer "lastmodified", null: false
    t.geometry "geom", limit: {:srid=>0, :type=>"geometry"}
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.index ["country", "placetype", "is_current", "lastmodified"], name: "spr_by_country"
    t.index ["is_ceased", "lastmodified"], name: "spr_by_ceased"
    t.index ["is_current", "lastmodified"], name: "spr_by_current"
    t.index ["is_deprecated", "lastmodified"], name: "spr_by_deprecated"
    t.index ["is_superseded", "lastmodified"], name: "spr_by_superseded"
    t.index ["is_superseding", "lastmodified"], name: "spr_by_superseding"
    t.index ["lastmodified"], name: "spr_by_lastmod"
    t.index ["latitude", "longitude", "is_current", "lastmodified"], name: "spr_by_centroid"
    t.index ["lonlat"], name: "index_spr_on_lonlat", using: :gist
    t.index ["min_latitude", "min_longitude", "max_latitude", "max_longitude", "placetype", "is_current", "lastmodified"], name: "spr_by_bbox"
    t.index ["name", "placetype", "is_current", "lastmodified"], name: "spr_by_name"
    t.index ["parent_id", "is_current", "lastmodified"], name: "spr_by_parent"
    t.index ["placetype", "is_current", "lastmodified"], name: "spr_by_placetype"
    t.index ["repo", "lastmodified"], name: "spr_by_repo"
    t.index ["wof_id"], name: "index_spr_on_wof_id"
  end

end
