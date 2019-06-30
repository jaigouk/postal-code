class CreateWofTables < ActiveRecord::Migration[5.2]
  def change
    create_table :ancestors do |t|
      t.integer :wof_id, null: false
      t.integer :ancestor_wof_id, null: false
      t.string :ancestor_placetype, null: false
      t.integer :lastmodified, null: false

      t.index [:wof_id]
      t.index [:ancestor_wof_id, :ancestor_placetype, :lastmodified], :name=>:ancestors_by_ancestor
      t.index [:wof_id, :ancestor_placetype, :lastmodified], :name=>:ancestors_by_wof_id
      t.index [:lastmodified], :name=>:ancestors_by_lastmod
    end

    create_table :concordances do |t|
      t.integer :wof_id, null: false
      t.decimal :other_id, :precision => 40, null: :false
      t.string :other_source
      t.integer :lastmodified

      t.index [:wof_id]
      t.index [:wof_id, :lastmodified], :name=>:concordances_by_wof_id
      t.index [:lastmodified], :name=>:concordances_by_lastmod
      t.index [:other_source, :other_id], :name=>:concordances_by_other_id
      t.index [:other_source, :other_id, :lastmodified], :name=>:concordances_by_other_lastmod
    end

    # neeed to deal with geojson
    create_table :geojson do |t|
      t.integer :wof_id, null: false
      t.jsonb :body
      t.integer :lastmodified, null: false

      t.index [:wof_id]
      t.index [:lastmodified], :name=>:geojson_by_lastmod
    end

    create_table :names do |t|
      t.integer :wof_id, null: false
      t.string :placetype
      t.string :country
      t.string :language
      t.string :extlang
      t.string :script
      t.string :region
      t.string :variant
      t.string :extension
      t.string :privateuse
      t.string :name
      t.integer :lastmodified, null: false

      t.index [:wof_id], :name=>:names_by_wofid
      t.index [:country, :privateuse, :placetype], :name=>:names_by_country
      t.index [:language, :privateuse, :placetype], :name=>:names_by_language
      t.index [:lastmodified], :name=>:names_by_lastmod
      t.index [:name, :placetype, :country], :name=>:names_by_name
      t.index [:name, :privateuse, :placetype, :country], :name=>:names_by_name_private
      t.index [:placetype, :country, :privateuse], :name=>:names_by_placetype
      
    end

    create_table :spr do |t|
      t.integer :wof_id, null: false
      t.integer :parent_id
      t.string :name
      t.string :placetype
      t.string :country
      t.string :repo

      t.decimal :latitude, precision: 10, scale: 7, null: false
      t.decimal :longitude, precision: 10, scale: 7, null: false
      t.decimal :min_latitude, precision: 10, scale: 7, null: false
      t.decimal :min_longitude, precision: 10, scale: 7, null: false
      t.decimal :max_latitude, precision: 10, scale: 7, null: false
      t.decimal :max_longitude, precision: 10, scale: 7, null: false

      t.integer :is_current
      t.integer :is_deprecated
      t.integer :is_ceased
      t.integer :is_superseded
      t.integer :is_superseding
      t.string :superseded_by
      t.string :supersedes
      t.integer :lastmodified, null: false

      t.index [:wof_id]
      t.index [:min_latitude, :min_longitude, :max_latitude, :max_longitude, :placetype, :is_current, :lastmodified], :name=>:spr_by_bbox
      t.index [:is_ceased, :lastmodified], :name=>:spr_by_ceased
      t.index [:latitude, :longitude, :is_current, :lastmodified], :name=>:spr_by_centroid
      t.index [:country, :placetype, :is_current, :lastmodified], :name=>:spr_by_country
      t.index [:is_current, :lastmodified], :name=>:spr_by_current
      t.index [:is_deprecated, :lastmodified], :name=>:spr_by_deprecated
      t.index [:lastmodified], :name=>:spr_by_lastmod
      t.index [:name, :placetype, :is_current, :lastmodified], :name=>:spr_by_name
      t.index [:parent_id, :is_current, :lastmodified], :name=>:spr_by_parent
      t.index [:placetype, :is_current, :lastmodified], :name=>:spr_by_placetype
      t.index [:repo, :lastmodified], :name=>:spr_by_repo
      t.index [:is_superseded, :lastmodified], :name=>:spr_by_superseded
      t.index [:is_superseding, :lastmodified], :name=>:spr_by_superseding

      t.column :geom, :geometry
      t.st_point :lonlat, geographic: true
      t.index :lonlat, using: :gist
    end
  end
end
