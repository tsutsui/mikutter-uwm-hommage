# -*- coding: utf-8 -*-

# 画像プレビューウィジェット
class ImageWidgetFactory

  # ファイル名を返す
  def filenames
    @image_boxes.map { |_| _.filename }.compact
  end

  # アップロードされる画像をIOで返す
  def files
    filenames.map do |name|
      File.open(name, 'rb') { |fp|
        StringIO.new(fp.read)
      }
    end
  end

  # イメージなし画像を返す
  def noimage_file
    Plugin[:"mikutter-uwm-hommage"].get_skin("noimage.png")
  end

  # コンストラクタ
  def initialize(filenames)
    @default_filenames = filenames
  end

  # ウィジェットを生成する
  def create(postbox)
    target_filenames = if !@image_boxes.empty?
      filenames
    else
      @default_filenames
    end

    @image_boxes = []

    base = Gtk::Box.new(:horizontal)
    
    button = Gtk::Button.new.add(Gtk::WebIcon.new(Skin.get('close.png'), 16, 16))

    button.ssc(:clicked) { |e|
      postbox.remove_extra_widget(:image)
    }

    image_area = []

    left_box = nil

    4.times { |i|
      image_box = Gtk::ImageBox.new(target_filenames[i], noimage_file)
      image_box.left = left_box

      if left_box
        left_box.right = image_box
      end

      @image_boxes << image_box
      image_area << image_box.widget

      left_box = image_box
    }

    base.pack_start(button, expand: false)

    box = Gtk::Box.new(:horizontal, 3)

    image_area.each { |area|
      box.pack_start(area, expand: false)
    }
    
    viewport = Gtk::Viewport.new(nil, nil)
    viewport.shadow_type = Gtk::ShadowType::NONE
    viewport.add(box)

    layout = Gtk::ScrolledWindow.new
    layout.shadow_type = Gtk::ShadowType::NONE
    layout.propagate_natural_width = true
    layout.vscrollbar_policy = :never
    layout.hscrollbar_policy = :automatic
    layout.add(viewport)

    base.pack_start(layout)

    base.show_all
    
    base
  end
end
