
module IshManager::ImagesHelper

  def image_doc
    image_tag 'icons/32x32/doc.png'
  end

  def image_pdf
    image_tag 'icons/32x32/pdf.png'
  end

  def image_linkedin
    image_tag 'icons/32x32/linkedin.png'
  end

  def image_facebook
    image_tag 'icons/32x32/facebook.png'
  end

  def image_twitter
    image_tag 'icons/32x32/twitter.png'
  end

  def image_github
    image_tag 'icons/32x32/github.png'
  end

  def image_email
    image_tag 'icons/32x32/email.png'
  end

  def image_flag locale
    # image_tag "flags/#{locale.to_s}.png"
    "[#{locale.to_s}]"
  end

  def image_city cityname
    image_tag 'icons/48x48/city.png'
  end

  def image_customize
    image_tag 'icons/28x28/customize.png'
  end

  def image_new_photo
    image_tag 'icons/48x48/new_photo.png'
  end

  def button_fb_login
    link_to image_tag('http://s3.amazonaws.com/ish-assets/loginWithFacebook.png'), user_omniauth_authorize_path(:facebook), :class => :fb
  end

  def image_logout
    image_tag 'icons/32x32/logout.png'
  end

  def image_expand
    # image_tag 'icons/28x28/expand.png'
    image_tag 'icons/16x16/expand_down.png'
  end

  def image_expand_down
    image_tag 'drag.png'
  end

  def image_contact
    image_tag 'http://s3.amazonaws.com/ish-assets/contact.png', :class => :contact
  end

  def image_expand_up
    image_tag 'drag.png'
  end

  def image_ppf
    image_tag 'ppf.gif'
  end

  def image_new_report
    image_tag 'icons/64x64/new_report.png'
  end

  def image_ish
    # image_tag 'logo.png'
    image_tag 'ish_logo_100.png'
  end

  def image_new_addritem
    image_tag 'icons/64x64/new_addritem.png'
  end

  def image_top
    image_tag('top.gif')
  end

  def image_scratchpad
    image_tag 'icons/64x64/scratchpad.png'
  end

  def image_settings
    image_tag 'icons/64x64/settings.png'
  end

  def image_extended_forms
    image_tag 'icons/64x64/extended_forms.png'
  end

  def image_close
    image_tag('close.png')
  end

  def image_email
    image_tag 'email.gif'
  end

  def image_add
    image_tag 'new.png'
  end

  def image_search args = {}
    image_tag 'icons/16x16/search.png', args
  end

  def image_cac
    s3_image_tag 'cac.png'
  end

  def image_delete
    raw('<i class="fa fa-trash"></i>')
  end

  def image_index
    image_tag 'icons/32x32/list.png'
  end

  def image_new
    raw('<i class="fa fa-plus-square"></i>')
		# image_tag 'icons/32x32/new.png', :alt => '[+]'
	end

  # @deprecated, should use image_3s
  def s3_image_tag input
    image_tag 'https://s3.amazonaws.com/ish-assets/' + input
  end

  def image_fb
    image_tag 'http://s3.amazonaws.com/ish-assets/loginWithFacebook.png'
  end

  def image_3s input
    image_tag 'https://s3.amazonaws.com/ish-assets/' + input
  end

  # @TODO:
  def video_thumb video
    warn 'todo wtf?'
    image_tag 'no_image.png'
  end

  #
  # missing stuff
  #

  def image_or_missing photo, size = :thumb

    if defined? photo.photo
      if defined? photo.photo.url
        if photo.photo.url == '/photos/original/missing.png'
          ;
        else
          return image_tag photo.photo.url(size)
        end
      end
    end

    image_missing
  end

  ## This needs to be a string url, not an image_tag. _vp_ 2020-02-25
  def image_missing
    'missing.png'
  end
  def image_missing_tag
    image_tag image_missing
  end

  def missing
    image_missing
  end

  def missing? item
    if defined? item.photo and defined? item.photo.url
      if item.photo.url == "/photos/original/missing.png"
        return true
      else
        return false
      end
    end

    return true
  end

  def image_vote_up
    image_tag 'icons/32x32/thumbs_up.png', :width => '16px'
  end

  def image_vote_down
    image_tag 'icons/32x32/thumbs_down.png', :width => '16px'
  end

  def image_contact
    image_tag 'http://s3.amazonaws.com/ish-assets/contact.png', :class => :contact
  end

  def image_restart
    t('apps.restart')
  end

  def image_my_profile
    image_tag 'icons/64x64/my-profile.png'
  end

  def trash_image_tag
    image_tag 'icons/20x20/trash.png'
  end

  def new_image_tag
    raw('<i class="fa fa-plus-square"></i>')
  end
  def new_img
    raw('<i class="fa fa-plus-square"></i>')
  end

  def is_public_image_tag resource
    if resource.is_public
      image_tag 'icons/20x20/public2.png'
    else
      image_tag 'icons/20x20/private.png'
    end
  end

  def edit_img
    raw('<i class="fa fa-pencil-square"></i>')
  end
  def image_edit
    raw('<i class="fa fa-pencil-square"></i>')
  end

  def youtube_image_tag video
    image_tag "https://img.youtube.com/vi/#{video.youtube_id}/0.jpg", :class => [ :youtube_img ]
  end

end
