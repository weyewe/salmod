COMPANY_NAME = "Salmod"
COMPANY_MOTO = "Sales Moderator"

COMPANY_DESCRIPTION= 'Need to control multiple warehouse sales organization? Use Salmod.com'


USER_ROLE = {
  :admin => "Admin",
  # create new user 
    # assign role to the user  
  
  
  :purchasing => "Purchasing", 
  # new item 
  # create purchase order to add item stock
  # add the recommended selling price 
  
  :inventory => "Inventory", # this sales can do 2 things: consumer sales and business sales. fuck it.
  # => when she is doing consumer sales, she pick: which warehouse ? 
  :sales => "Sales", 
  
  # 
  # :business_sales => "BusinessSales", 
  # # doing sales as well, but with delivery address. 
  # 
  # :consumer_sales => "ConsumerSales"
  # # purely doing sales, give sales price and that's it, give the item to the client 
  # # the item deducted will be from the store she is attached to 
  :mechanic => "Mechanic"
}

 

DEV_EMAIL = "w.yunnal@gmail.com"

TRUE_CHECK = 1
FALSE_CHECK = 0

PROPOSER_ROLE = 0 
APPROVER_ROLE = 1 

IMAGE_ASSET_URL = {
  
  # MSG BOX
  :alert => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/alert.png',
  :background => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/background.png',
  :confirm => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/confirm.png',
  :error => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/error.png',
  :info => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/info.png',
  :question => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/question.png',
  :success => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/success.png',
  
  
  # FONT 
  :font_awesome_eot => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.eot',
  :font_awesome_svg => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.svg',
  :font_awesome_svgz =>'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.svgz',
  :font_awesome_ttf => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.ttf',
  :font_awesome_woff => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.woff',  
  
  
  # BOOTSTRAP SPECIFIC 
  :glyphicons_halflings_white => 'http://s3.amazonaws.com/salmod/app_asset/bootstrap/glyphicons-halflings-white.png',
  :glyphicons_halflings_black => 'http://s3.amazonaws.com/salmod/app_asset/bootstrap/glyphicons-halflings.png',
  
  # jquery UI-lightness 
  :ui_bg_diagonal_thick_18 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_diagonals-thick_18_b81900_40x40.png',
  :ui_bg_diagonal_thick_20 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_diagonals-thick_20_666666_40x40.png',
  :ui_bg_flat_10 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_flat_10_000000_40x100.png' , 
  :ui_bg_glass_100_f6f6f6 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_100_f6f6f6_1x400.png',
  :ui_bg_glass_100 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_100_fdf5ce_1x400.png',
  :ui_bg_glass_65 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_65_ffffff_1x400.png',
  :ui_bf_gloss_wave => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_gloss-wave_35_f6a828_500x100.png',
  :ui_bg_highlight_soft_100 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_gloss-wave_35_f6a828_500x100.png',
  :ui_bg_highlight_soft_75 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_highlight-soft_75_ffe45c_1x100.png',
  :ui_icons_222222 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_222222_256x240.png',
  :ui_icons_228ef1 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_228ef1_256x240.png',
  :ui_icons_ef8c08 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ef8c08_256x240.png',
  :ui_icons_ffd27a => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ffd27a_256x240.png',
  :ui_icons_ffffff => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ffffff_256x240.png',
  :ui_bg_highlight_soft_100_eeeeee => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_highlight-soft_100_eeeeee_1x100.png',
  
  
  # APP_APPLICATION.css 
  :jquery_handle => 'http://s3.amazonaws.com/salmod/app_asset/app_application/handle.png',
  :jquery_handle_vertical => 'http://s3.amazonaws.com/salmod/app_asset/app_application/handle-vertical.png',
  :login_bg => 'http://s3.amazonaws.com/salmod/app_asset/app_application/login-bg.png',
  :user_signin => 'http://s3.amazonaws.com/salmod/app_asset/app_application/user.png',
  :password => 'http://s3.amazonaws.com/salmod/app_asset/app_application/password.png',
  :password_error => 'http://s3.amazonaws.com/salmod/app_asset/app_application/password_error.png',
  :check_signin => 'http://s3.amazonaws.com/salmod/app_asset/app_application/check.png',
  :twitter => 'http://s3.amazonaws.com/salmod/app_asset/app_application/twitter_btn.png',
  :fb_button => 'http://s3.amazonaws.com/salmod/app_asset/app_application/fb_btn.png',
  :validation_error => 'http://s3.amazonaws.com/salmod/app_asset/app_application/validation-error.png',
  :validation_success => 'http://s3.amazonaws.com/salmod/app_asset/app_application/validation-success.png',
  :zoom => 'http://s3.amazonaws.com/salmod/app_asset/app_application/zoom.png',
  :logo => 'http://s3.amazonaws.com/salmod/app_asset/app_application/logo.png'
  
  
  
  
  
}





SALES_ENTRY_CASE = {
  :service => 1 , 
  :item => 2 
}

# each entry case must be supported by the document 
STOCK_ENTRY_CASE = {
  # => 0-199 == addition 
    # => 0-9 == internal addition
  :stock_migration => 0 , 
  :stock_adjustment =>1,
  :scrap => 2,  # broken 
  :stock_conversion =>3, 
  
  
    # => 10-19 == related to vendor 
  :purchase => 10 ,  
  :purchase_return => 11,
    
    # => 20-29 == related to sales to customer  
  :sales => 20 ,
  :sales_return => 21 
  
} 

MUTATION_CASE = {
  :stock_migration => 0, 
  :sales_order => 1 ,
  :stock_conversion_source => 2 ,
  
  # from 30 onward, it is the addition case 
  :sales_return => 30,
  :stock_conversion_target => 31 ,
  :stock_conversion_target => 32
}

MUTATION_STATUS = {
  :deduction  => 1 ,
  :addition => 2 
}

ITEM_STATUS = {
  :ready => 1 , 
  :scrap => 2, 
  :pending_receival => 3 ,
  :pending_delivery => 4 ,
  :on_delivery => 5 
}


CONVERSION_STATUS = {
  :disassembly => 1, 
  :assembly => 2 
}
STOCK_CONVERSION_ENTRY_STATUS ={
  :source => 1 , 
  :result => 2 
}





CONTINUOUS_FORM_WIDTH = 792
HALF_CONTINUOUS_FORM_LENGTH = 342
FULL_CONTINUOUS_FORM_LENGTH = 684

LOCAL_TIME_ZONE = "Jakarta"
# in_time_zone(LOCAL_TIME_ZONE)


 