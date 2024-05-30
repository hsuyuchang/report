drop database if exists iSpanProject;
go
create database iSpanProject;
GO
use iSpanProject;

drop table if exists restaurantckeditor;
drop table if exists restaurantreserve;
drop table if exists restaurantseat;
drop table if exists restaurantrecord;
drop table if exists restaurantphoto;
drop table if exists restaurantdetail;

drop table if exists menu_cart_item;



drop table if exists menu_cart;
drop table if exists menu_order_detail;
drop table if exists menu_order;
drop table if exists menu;

drop table if exists mall_shopping_cart;
drop table if exists mall_order_detail;
drop table if exists mall_order;

drop table if exists product_photo;
drop table if exists product;
drop table if exists product_category;
drop table if exists restaurant_data

drop table if exists member_coupon;
drop table if exists coupon;
drop table if exists ad_check;
drop table if exists ad_data;

drop table if exists reply;
drop table if exists contactadmin;

drop table if exists courier;
drop table if exists admin;
drop table if exists member;
drop table if exists restaurant;

CREATE TABLE restaurant (
    restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    uniformnumbers VARCHAR(8) NOT NULL,
    password VARCHAR(MAX) NOT NULL,
    salt NVARCHAR(MAX),
    county NVARCHAR(20) NOT NULL ,
	district NVARCHAR(20) NOT NULL,
	address NVARCHAR(200) NOT NULL,
	phone NVARCHAR(20) NOT NULL,
	longitude decimal(18,15),
    latitude decimal(18,15),
    open_time TIME(0),
    close_time TIME(0),
    style NVARCHAR(10) CHECK (style IN ('外帶外送', '預約內用')),
	introduce NVARCHAR(150),
);

create table admin(
	admin_id int primary key identity(1, 1),
	email varchar(250) not null,
	password varchar(MAX) not null,
	salt nvarchar(MAX),
	name nvarchar(30) not null,
	status varchar(2) default('1'),
);

create table member(
	member_id int primary key identity(1, 1),
	email varchar(250) not null,
	password varchar(MAX) not null,
	salt nvarchar(MAX),
	name nvarchar(30) not null,
	phone varchar(30),
	county nvarchar(20) not null,
	district nvarchar(20) not null,
	address varchar(200) not null,
	status varchar(2) default('1'),
	photo varbinary(max),
	registeration_date datetime not null,
	bin char(6),
	pan varchar(12),
	luhn char(1),
	existence varchar(2) default('1'),
);

create table courier(
	courier_id int primary key identity(1, 1),
	email varchar(250) not null,
	password varchar(MAX) not null,
	salt nvarchar(MAX),
	name nvarchar(30) not null,
	phone varchar(30),
	status varchar(2) default('1'),
	online_status varchar(2) default('0'),
	photo varbinary(MAX),
	registeration_date datetime not null,
	longitude decimal(18,15),
	latitude decimal(18,15),
);

CREATE TABLE product_category (
    product_category_id INT IDENTITY(1,1) PRIMARY KEY,
    product_category NVARCHAR(200) NOT NULL
);

create table coupon (
	coupon_id int primary key identity(1, 1),
	code nvarchar(100) not null,
	type nvarchar(100) not null,
	discount decimal(3, 2) not null,
	usage_price int not null,
	start_time datetime not null,
	end_time datetime not null

);

create table contactadmin(
	contactadmin_id int primary key identity(1, 1) ,
	name nvarchar(100) not null,
	email nvarchar(250) not null,
	contenttext nvarchar(max) ,
	status nvarchar(10) not null,
	created_time datetime not null,

);


CREATE TABLE restaurantphoto (
    photo_id INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_id INT NOT NULL,
	photomain bit default 0 CHECK (photomain IN ('0', '1')),
	photofile VARBINARY(MAX) NOT NULL,
   CONSTRAINT FK_RestaurantPhotos_Restaurant_ID 
    FOREIGN KEY (restaurant_id) 
    REFERENCES restaurant(restaurant_id) 
);

CREATE TABLE restaurantrecord (
    restaurantrecord_id INT IDENTITY(1,1) PRIMARY KEY,
    timeper NVARCHAR(50) NOT NULL ,
    starttime time(0) NOT NULL,
    endtime time(0) NOT NULL,
    price INT NOT NULL,
    note nvarchar(MAX),
    restaurant_id INT NOT NULL,
    CONSTRAINT FK_restaurantrecord_restaurant_id
        FOREIGN KEY (restaurant_id) 
        REFERENCES restaurant(restaurant_id) 
);

CREATE TABLE restaurantseat (
    seat_id INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_id INT NOT NULL,
	restaurantrecord_id INT NOT NULL,
	seattimeper NVARCHAR(50) NOT NULL ,
	opentime time(0) not null,
	openday date not null,
    tablefor varchar(10) NOT NULL,
    seatstate NVARCHAR(12) DEFAULT '未預約' CHECK (seatstate IN ('未預約', '已預約')),
    CONSTRAINT FK_restaurantseat_restaurant_id
        FOREIGN KEY (restaurant_id) 
        REFERENCES restaurant(restaurant_id) ,
	CONSTRAINT FK_restaurantseat_restaurantrecord_id
        FOREIGN KEY (restaurantrecord_id) 
        REFERENCES restaurantrecord(restaurantrecord_id)
);

CREATE TABLE restaurantreserve (
    reserved_id INT IDENTITY(1,1) PRIMARY KEY,
    seat_id INT,
    member_id INT NOT NULL,
	restaurant_id INT NOT NULL,
    reserveday date not null,
	reservetime time(0) not null,
    customer INT NOT NULL,
    reservedstate NVARCHAR(50) DEFAULT '已預約' CHECK (reservedstate IN ('已預約', '已結單', '已取消','已付款')),
	amount INT NOT NULL,
	qrcode_photo VARBINARY(MAX),
    CONSTRAINT FK_restaurantreserve_Seat_ID 
        FOREIGN KEY (seat_id) 
         REFERENCES restaurantseat(seat_id) ON DELETE SET NULL,
	 
	 CONSTRAINT FK_restaurantreserve_restaurant_id
        FOREIGN KEY (restaurant_id) 
        REFERENCES restaurant(restaurant_id),

    CONSTRAINT FK_RestaurantReserve_Member_ID 
       FOREIGN KEY (member_id) 
       REFERENCES member(member_id),
);


create table restaurantckeditor(
	id INT IDENTITY(1,1) PRIMARY KEY,
	html Nvarchar(max),
	restaurant_id INT NOT NULL UNIQUE,
		CONSTRAINT FK_restaurantckitor_restaurant_id
		FOREIGN KEY (restaurant_id) 
		REFERENCES restaurant(restaurant_id),
)


create table menu (
	menu_id int primary key identity(1, 1),
	restaurant_id int not null,
	[name] nvarchar(200) not null,
	price int not null,
	[description] nvarchar(2000),
	photo varbinary(max),
	
	foreign key (restaurant_id) references restaurant (restaurant_id),
);

create table menu_order (
	order_id int primary key identity(1, 1),
	member_id int not null,
	restaurant_id int not null,
	courier_id int,
	order_type nvarchar(200) not null,
	delivery_address nvarchar(200),
	delivery_fee int default 0,
	platform_fee int default 0,
	sub_total int not null,
	total int not null,
	payment_type nvarchar(200) not null,
	status nvarchar(200) not null,
	reservation_time datetime not null,
	qrcode varbinary(max),
	created_time datetime not null,

	foreign key (member_id) references member (member_id),
	foreign key (restaurant_id) references restaurant (restaurant_id),
	foreign key (courier_id) references courier (courier_id)
);

create table menu_order_detail (
	order_detail_id int primary key identity(1, 1),
	order_id int not null,
	menu_id int not null,
	price int not null,
	quantity int not null,

	foreign key (order_id) references menu_order (order_id),
	foreign key (menu_id) references menu (menu_id)
);

create table menu_cart (
	cart_id int primary key identity(1, 1),
	member_id int not null,
	restaurant_id int not null,
	order_type nvarchar(200) not null,
	delivery_fee int default 0,
	platform_fee int default 0,

	foreign key (member_id) references member (member_id),
	foreign key (restaurant_id) references restaurant (restaurant_id)
);

create table menu_cart_item (
	item_id int primary key identity(1, 1),
	cart_id int not null,
	menu_id int not null,
	quantity int not null,
	created_time datetime not null,

	foreign key (cart_id) references menu_cart (cart_id),
	foreign key (menu_id) references menu (menu_id) ON DELETE CASCADE,
);

CREATE TABLE product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_id INT NOT NULL,
    product_category_id INT NOT NULL,
    product_name NVARCHAR(200) NOT NULL,
    product_price INT NOT NULL,
    product_description NVARCHAR(3000),
    shelf_time DATETIME NOT NULL,
    product_status TINYINT NOT NULL,
    audit_status TINYINT NOT NULL,
    inventory_quantity INT NOT NULL,
	photo VARBINARY(MAX) NOT NULL,
   
    FOREIGN KEY (product_category_id) REFERENCES product_category(product_category_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id)
);

CREATE TABLE product_photo (
    photo_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
	product_photo VARBINARY(MAX) NOT NULL,

    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE mall_order (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    member_id INT NOT NULL,
    order_total_amount INT NOT NULL,
    order_status NVARCHAR(20) NOT NULL CHECK (order_status IN ('CREATED', 'PAID', 'SHIPPED', 'COMPLETED', 'CANCELED', 'RETURN')),
    order_time DATETIME NOT NULL,
    payment_time DATETIME NOT NULL,
    shipping_time DATETIME NOT NULL,
    shipping_address NVARCHAR(200) NOT NULL,

    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

CREATE TABLE mall_order_detail (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_price INT NOT NULL,
    quantity INT NOT NULL,
    order_time DATETIME NOT NULL,

    FOREIGN KEY (order_id) REFERENCES mall_order(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE mall_shopping_cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    member_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    added_cart_time DATETIME NOT NULL,

    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

create table member_coupon(
	member_coupon_id int primary key identity(1, 1),
	member_id int not null,
	coupon_id int not null,
	status tinyint not null default 0

	foreign key (member_id) references member (member_id),
	foreign key (coupon_id) references coupon(coupon_id)
);

create table ad_data (
	ad_id int primary key identity(1, 1),
	restaurant_id int not null,
	location nvarchar(20) not null,
	photo varbinary(MAX),
	url nvarchar(100) not null,
	content nvarchar(100) not null,
	days int not null,
	price int not null,
	start_time date not null,
	end_time date not null,
	status nvarchar(20) not null,
	created_time datetime not null

	foreign key (restaurant_id) references restaurant (restaurant_id)
);

create table ad_check(
	ad_check_id int primary key identity(1, 1),
	ad_id int not null,
	check_count int not null

	foreign key (ad_id) references ad_data(ad_id)
);

create table reply(
	reply_id int primary key identity(1, 1),
	contactadmin_id int not null,
	email nvarchar(250) ,
	contenttext nvarchar(max) not null,
	reply_time datetime not null,

	foreign key (contactadmin_id) references contactadmin(contactadmin_id)
);


-- 餐廳資料
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,longitude,latitude,phone,style,open_time,close_time,introduce)values('勁情享用','89640001','C7fI7f4CMYWd0j/PQj3gJtX8hUI5thh3InaVmRcw1t0=','ak4ScGJvhVwAyJJJt2q0UA==','高雄市','前金區','七賢二路224號',120.293437517227730,22.632889995717100,'091234567','外帶外送','11:00','20:00','勁情享用，是一家融合了中式和西式美食元素的獨特餐廳。無論您是喜歡傳統的中菜還是喜歡創新的西餐，這裡都能滿足您的味蕾。我們的菜單精心設計，包括新鮮的海鮮、多樣的烤肉、美味的湯品和精緻的甜點，為您帶來舌尖上的享受');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,longitude,latitude,phone,style,open_time,close_time,introduce)values('沐瀧家拉麵','89640002','C7fI7f4CMYWd0j/PQj3gJtX8hUI5thh3InaVmRcw1t0=','ak4ScGJvhVwAyJJJt2q0UA==','高雄市','前金區','自強二路166號',120.294569500000000,22.627588200000000,'0910586923','外帶外送','11:00','20:00','沐瀧家拉麵，專注於日式風味，提供正宗豚骨拉麵及多款特色湯底。配以彈牙麵條和新鮮配料，每一口都是滿滿的幸福。我們的餐廳環境溫馨舒適，是您品嚐美味拉麵的絕佳選擇');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,longitude,latitude,phone,style,open_time,close_time,introduce)values('好吃飯館','89640003','C7fI7f4CMYWd0j/PQj3gJtX8hUI5thh3InaVmRcw1t0=','ak4ScGJvhVwAyJJJt2q0UA==','高雄市','苓雅區','青年一路4巷1號',120.291232500000000,22.628637800000000,'0983624578','外帶外送','11:00','20:00','好吃飯館融合多元的美食文化，提供多樣化的料理選擇，從地中海風味到亞洲口味，以新鮮食材和創意烹飪方式打造每一道菜品，讓您享受美味的用餐時刻');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,longitude,latitude,phone,style,open_time,close_time,introduce)values('私房小廚','89640004','C7fI7f4CMYWd0j/PQj3gJtX8hUI5thh3InaVmRcw1t0=','ak4ScGJvhVwAyJJJt2q0UA==','高雄市','前金區','六合二路149號',120.2963545,22.6312242,'0906452983','外帶外送','11:00','20:00','私房小廚提供獨特的早餐、消夜體驗，我們以新鮮食材和創意料理為特色。從傳統至創新，每一道菜品都充滿驚喜，無論是悠閒享用早晨咖啡迎接新的一天，或是夜貓子找尋消夜美食填補五臟胃，私房小廚都是您的理想選擇');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,longitude,latitude,phone,style,open_time,close_time,introduce)values('巷口食堂','89640005','C7fI7f4CMYWd0j/PQj3gJtX8hUI5thh3InaVmRcw1t0=','ak4ScGJvhVwAyJJJt2q0UA==','高雄市','前金區','自強二路18號',120.2965668,22.6211591,'0913852625','外帶外送','11:00','20:00','歡迎光臨「巷口食堂」，我們是一家溫馨氛圍的小餐廳，提供美食與熱情服務，讓客人感受家的溫暖，菜單從早餐到晚餐品項皆精心準備，無論是單人用餐還是家庭聚會，都能在此享受美好時光');

insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('火炙炭烤坊','89641111','C7fI7f4CMYWd0j/PQj3gJtX8hUI5thh3InaVmRcw1t0=','ak4ScGJvhVwAyJJJt2q0UA==','高雄市','三民區','建工路497號','0912345678','預約內用','位於市中心的「炭火燒烤坊」以正統口味為您呈現最道地的燒烤饗宴。我們選用上等食材，搭配獨特調味，烤出肉質鮮嫩、香氣撲鼻的美味佳餚，舒適的用餐環境，讓您享受輕鬆愉悅的用餐時光，無論是與親友共聚或商務宴請，皆是您的最佳選擇。','08:00','22:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('滋味餐廳','89641112','f7INQWalrg2jJJBK1O/ECNERyRDEDvPs+ofWFuz4088=','wnWdddxse7ouDBj18xdgww==','高雄市','三民區','九如一路720號','0912345672','預約內用','歡迎光臨「滋味餐廳」！我們以豐富多樣的自助餐風格為您帶來美味饗宴。精心準備的各式料理包括國際美食、新鮮生魚片和精緻甜點，舒適寬敞的用餐環境，讓您盡情享受無限美味。','11:00','22:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('素味軒','89641113','Dpt2XS/6EBHdgSyyOQLXPawe0q6GJubsgNn8EGVU+c4=','1hIr27oyczXtOYch6SYiDg==','高雄市','鼓山區','濱海一路109-1號','0912345678','預約內用','歡迎來到「素味軒」！我們提供獨特的疏食風格自助餐，滿足您的味蕾與健康需求。新鮮蔬果、精緻主菜、營養點心應有盡有。舒適雅致的用餐環境，讓您享受輕鬆用餐體驗，無限供應，盡情品嘗健康美味！','08:00','21:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('綠蔬堂','89641114','oNrskPi9StQokxlwJiXHZX3ZxISokZrL/jC4xpQTsFU=','f2kWBtEc8jJr8zHQ5pSpcg==','高雄市','鼓山區','翠華路246號','0912345678','預約內用','歡迎光臨「綠蔬堂」！我們專注於健康蔬食，提供多樣化的素食選擇，包括新鮮的有機蔬菜、豆類和穀物。我們以健康為本，精心烹製每一道菜品，為您打造營養豐富又美味的餐點，歡迎您來品嘗我們的健康美食！','07:00','21:30');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('意式風情','87941115','BBHSOZjCakEnRqCWNxZMwF7KcvJp5mLbFGpkO0nnJrk=','3IFUOcz/5s2tD22fqsbgqA==','高雄市','左營區','崇德路801號','0912345678','預約內用','歡迎來到「意式風情」！我們提供正宗義式風格的吃到飽餐廳。從新鮮沙拉到精緻披薩，再到美味意粉，每一道料理都彰顯義大利美食的精髓，舒適優雅的用餐環境，讓您盡情享受美食之旅，無盡的供應，帶給您無窮的滋味體驗！','08:00','22:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('牛宴坊','87941116','dxMDjt/gvZk1AYXPwB1hi9jM+KR1SCR0BB1GTZXHFeQ=','M79nDDW//0dNRLQKd12g0Q==','高雄市','左營區','蓮潭路400號','0912345678','預約內用','歡迎光臨「牛宴坊」！我們是一家專業的牛排館，提供吃到飽服務，精選頂級牛肉，以獨特手法烹調，保留肉質原味，從沙拉到主菜，每道料理都精心製作，讓您享受極致美味，溫馨舒適的環境，讓您盡情品嚐。','11:00','16:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('鍋蓋飄香','87941117','kLcwzULBU7+a0buxpUSmu348iudo8gIiIY0CqrhOM2w=','4ZaznlP2IY4yOP7eFct6DA==','高雄市','楠梓區','德民路24號','0912345678','預約內用','歡迎光臨「鍋蓋飄香」！我們是專業的火鍋吃到飽餐廳，提供各式新鮮食材和多種湯底，滿足您的味蕾需求，品質保證的食材，美味湯底，舒適用餐環境，讓您享受美味火鍋的愉悅體驗。','11:00','20:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('牛豬藝廚房','87941118','xQIOwqE2dhJI7X8S+ClQ3UdxnYMgJa3OwH5tcGq6ml0=','IAY07JUMvqKpFbUPJhIQbw==','高雄市','楠梓區','高雄大學路700號','0912345678','預約內用','歡迎光臨「牛豬藝廚房」！我們專注於精緻的牛排和豬排料理，每一份都經過精心挑選的肉質和獨特的調味，讓您品嚐到最美味的口感和風味，我們致力於提供高品質的用餐體驗，讓您享受豐富美味的餐點。','11:00','20:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('辣不辣','87941119','zPBqoSokM4iG1IGg/cG6Rm6sTElfCSxyLhQbXYT1ixU=','c6UkMXtieJQBAIDfSO4xrg==','高雄市','前鎮區','中華五路789號','0912345678','預約內用','歡迎來到「辣不辣」！我們是專業的麻辣鍋吃到飽餐廳，提供多種辣度的湯底，配以新鮮食材和精選肉品，讓您盡情享受麻辣的風味，舒適寬敞的用餐環境，讓您和朋友家人一起度過美味又溫暖的時光。','11:00','20:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('和風屋','87941120','MlALTheyd1zBqcxFgqeA+dowZgQCBpdlNd6ASAzfpdA=','7T0zkIcvy1Jy0yEN7IBypA==','高雄市','前鎮區','中安路1-1號','0912345678','預約內用','歡迎來到「和風屋」！我們以正宗的日式風格為您帶來獨特的餐飲體驗，從新鮮的壽司和刺身到燒烤和拉麵，每道菜都經過精心製作，讓您感受到日本料理的美味和風情，舒適優雅的用餐環境，讓您沉浸在舒適的氛圍中享受美食。','11:00','20:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('櫻花日本餐廳','87941121','t2DIPqdSj45dVtyOAVTJUN1jvZyAhX92X6lbFyb3r00=','LQfnsbB4jLED4b6q0uK7jQ==','高雄市','前金區','五福三路57號','0912345678','預約內用','歡迎來到「櫻花日本餐廳」！我們匯集了日本風味的精髓，提供多樣化的日式料理，包括新鮮的壽司、炸物和拉麵等。精心挑選的食材，加上正宗的烹飪技巧，讓您在這裡品嚐到地道的日本美食，舒適雅致的用餐環境，讓您享受純正的日式饗宴。','08:00','22:00');
insert into restaurant(name, uniformnumbers,password,salt,county,district,address,phone,style,introduce,open_time,close_time)values('麵屋一燈','87941122','bmrD7Hj7qY2BuBOrmbqTgkMy1uMMqjUtzURecreXmmQ=','+U1S9IsV7Kg5x8WEe6VxdQ==','高雄市','前金區','成功一路266-1號','0912345678','預約內用','歡迎來到「麵屋一燈」！我們專注於日本風味的拉麵，每一碗都是精心烹製，擁有豐富的湯頭和彈牙的麵條，讓您品味到道地的日式風情，獨特的配料組合和精緻的裝飾，為您帶來一場口味和視覺的雙重享受。','11:00','16:00');
go

--營業紀錄
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(6,'早上','08:00','11:00',699);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(6,'中午','11:30','14:00',799);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(6,'晚上','18:00','22:00',899);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(7,'中午','11:00','13:00',999);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(7,'下午','14:00','16:00',799);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(7,'晚上','18:00','22:00',1399);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(8,'早上','8:00','10:30',699);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(8,'中午','11:30','14:00',899);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(8,'晚上','18:00','21:00',1099);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(9,'早上','7:00','9:00',399);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(9,'中午','11:00','11:00',699);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(9,'晚上','18:00','20:30',999);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(10,'早上','08:00','11:00',699);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(10,'中午','11:30','14:00',799);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(10,'晚上','18:00','22:00',899);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(11,'中午','11:00','13:00',999);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(11,'下午','14:00','16:00',799);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(12,'早上','08:00','11:00',699);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(12,'中午','11:30','14:00',799);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(12,'晚上','18:00','22:00',899);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(13,'中午','11:00','13:00',999);
insert into restaurantrecord(restaurant_id,timeper,starttime,endtime,price) values(13,'下午','14:00','16:00',799);
go

-- 餐廳圖片資料
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 1,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\restaurant1.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 2,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\restaurant2.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 3,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\restaurant3.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 4,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\restaurant4.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 5,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\restaurant5.jpg', SINGLE_BLOB) AS pic

INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 6,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\A.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 7,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\B.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 8,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\C.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 9,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\D.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 10,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\E.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 11,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\F.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 12,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\G.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 13,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\H.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 14,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\I.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 15,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\J.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 16,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\K.jpg', SINGLE_BLOB) AS pic
INSERT INTO restaurantphoto (restaurant_id, photomain, photofile)SELECT 17,1,BulkColumn  FROM OPENROWSET(BULK 'C:\restaurantImage\L.jpg', SINGLE_BLOB) AS pic
go

--營業座位資料
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)VALUES (6,2,'中午','12:00:00', '四人桌', '2024-04-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)VALUES (6,2,'中午','11:45:00', '六人桌', '2024-04-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)VALUES (6,3,'晚上','18:00:00', '六人桌', '2024-04-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)VALUES (6,3,'晚上','18:10:00', '四人桌', '2024-04-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)VALUES (6,3,'晚上','18:15:00', '四人桌', '2024-04-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)VALUES (6,3,'晚上','18:20:00', '六人桌', '2024-04-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)VALUES (6,3,'晚上','18:30:00', '六人桌', '2024-04-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)VALUES (6,3,'晚上','18:00:00', '四人桌', '2024-04-03');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:30:00', '六人桌', '2024-04-03');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,2,'中午','11:30:00', '四人桌', '2024-04-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,2,'中午','11:45:00', '四人桌', '2024-04-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:00:00', '六人桌', '2024-04-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:15:00', '四人桌', '2024-04-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:30:00', '四人桌', '2024-04-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,2,'中午','11:30:00', '四人桌', '2024-04-12');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:00:00', '四人桌', '2024-04-12');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:10:00', '六人桌', '2024-04-12');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:20:00', '四人桌', '2024-04-12');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:00:00', '六人桌', '2024-04-14');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:00:00', '四人桌', '2024-04-14');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:15:00', '六人桌', '2024-04-14');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:00:00', '四人桌', '2024-04-18');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:30:00', '六人桌', '2024-04-18');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:00:00', '四人桌', '2024-04-20');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:00:00', '六人桌', '2024-04-20');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:15:00', '四人桌', '2024-04-22');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:30:00', '六人桌', '2024-04-22');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:00:00', '四人桌', '2024-04-25');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (6,3,'晚上','18:15:00', '四人桌', '2024-04-25');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '四人桌', '2024-04-06');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '六人桌', '2024-04-06');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '四人桌', '2024-03-06');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '六人桌', '2024-03-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:30:00', '四人桌', '2024-03-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:45:00', '六人桌', '2024-03-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','19:00:00', '四人桌', '2024-03-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '六人桌', '2024-03-08');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '四人桌', '2024-03-10');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '六人桌', '2024-03-10');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '四人桌', '2024-03-10');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3, '晚上','18:00:00','六人桌', '2024-03-10');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,opentime,tablefor,openday)values (7,3,'晚上','18:00:00', '四人桌', '2024-03-13');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,tablefor,opentime,openday)values (8,3,'晚上', '四人桌','18:00:00', '2024-03-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,tablefor,opentime,openday)values (8,3, '晚上','四人桌','18:00:00', '2024-03-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,tablefor,opentime,openday)values (9,3,'晚上', '四人桌','18:00:00', '2024-03-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,tablefor,opentime,openday)values (10,3, '晚上','四人桌','18:00:00', '2024-03-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,tablefor,opentime,openday)values (11,3,'晚上', '四人桌','18:00:00', '2024-03-02');
insert into restaurantseat(restaurant_id,restaurantrecord_id,seattimeper,tablefor,opentime,openday)values (12,3, '晚上','四人桌','18:00:00', '2024-03-02');
go

-- 會員資料
insert into [iSpanProject].[dbo].[member]([email],[password],[salt],[name],[phone],[county],[district],[address],[status],[registeration_date],[bin],[pan],[luhn],[photo])SELECT 'ispantest02@gmail.com','x/TMzRWAzVuDCjMy+mNtN8AH7cf8XnRaeqmFd4/13FA=','p2RxOSxxWHEtmZXpnir+ag==','Stanley','09467821','高雄市','三民區','高雄市三民區新民路124號','1' ,'2024-04-02','123456','123456789','1', BulkColumn  FROM OPENROWSET(BULK 'C:/restaurantImage/member1.png', SINGLE_BLOB) as membImg;
insert into [iSpanProject].[dbo].[member]([email],[password],[salt],[name],[phone],[county],[district],[address],[status],[registeration_date],[bin],[pan],[luhn],[photo])SELECT 'user2@gmail.com','xPcnrboyWoSjxpOgFgObSIj60V69fnNYhU+MsNQmgTc=','RIbUHCMo0PcYpoW6Oh1fvA==','Cynthia','09467821','高雄市','三民區','高雄市三民區建工路415號','1','2021-02-02','213456','213456789','1', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/member2.png', SINGLE_BLOB) as membImg;
insert into [iSpanProject].[dbo].[member]([email],[password],[salt],[name],[phone],[county],[district],[address],[status],[registeration_date],[bin],[pan],[luhn],[photo])SELECT 'user3@gmail.com','bjCUDP/JFeZ4DH408BIjaAQbKsvBoBBWkpzqUVmRYDI=','coSTJpoOF4L8z6Hqm4A02w==','Cindy','09467821','高雄市','三民區','高雄市三民區新民路124號','1','2021-02-03','321456','321456789','1', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/member3.png', SINGLE_BLOB) as membImg;
insert into [iSpanProject].[dbo].[member]([email],[password],[salt],[name],[phone],[county],[district],[address],[status],[registeration_date],[bin],[pan],[luhn],[photo])SELECT 'user4@gmail.com','O/HeeT7xP4DwadpKK8oN8R6QoUUY1qudpStHX5iTWxw=','/QogBjfoY1JGvyYO5avvXQ==','John','09467821','高雄市','三民區','高雄市三民區大豐二路126號','1','2021-02-04','432156','432156789','1', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/member4.png', SINGLE_BLOB) as membImg;
insert into [iSpanProject].[dbo].[member]([email],[password],[salt],[name],[phone],[county],[district],[address],[status],[registeration_date],[bin],[pan],[luhn],[photo])SELECT 'user5@gmail.com','UnyU+x3GTFlmGNF34+ytAJ762ZtdaooBP4IC1JYOekc=','gRE/ZIU53aVF7SeFoCKSAA==','Ame','09467821','高雄市','三民區','高雄市三民區昌裕街187號','1','2021-02-05','543216','543216789','1', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/member5.png', SINGLE_BLOB) as membImg;
insert into [iSpanProject].[dbo].[member]([email],[password],[salt],[name],[phone],[county],[district],[address],[status],[registeration_date],[bin],[pan],[luhn],[photo])SELECT 'user6@gmail.com','3+I8zSdbn8xGou++SW7kuuQxWz5VxteLByR4B7ZYUj0=','PHowA/DQwWvpNXjxs89wSQ==','Shara','09467821','高雄市','三民區','高雄市三民區建工路347號','1','2021-02-06','654321','654321789','1', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/member6.png', SINGLE_BLOB) as membImg;
insert into [iSpanProject].[dbo].[member]([email],[password],[salt],[name],[phone],[county],[district],[address],[status],[registeration_date],[bin],[pan],[luhn],[photo])SELECT 'user7@gmail.com','UgXMAkwGk94FAtWjqXFmTradR9kmef/4ogHh9uN8sRE=','SLkGw58IwHzo+sEhf0Brjw==','Anderson','09467821','高雄市','三民區','高雄市三民區新民路124號','1','2021-02-07','765432','765432189','1', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/member7.png', SINGLE_BLOB) as membImg;
insert into [iSpanProject].[dbo].[member]([email],[password],[salt],[name],[phone],[county],[district],[address],[status],[registeration_date],[bin],[pan],[luhn],[photo])SELECT 'user8@gmail.com','d9KdoOAlMAoaJQ3XWK5t10Ua6a9YIiQZPzpGeNanYqs=','N3fyBZCpicUg1HvTcnJZSQ==','Jason','09467821','高雄市','三民區','高雄市三民區新民路124號','1','2021-02-08','876543','876543219','1', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/member8.png', SINGLE_BLOB) as membImg;
go

-- 餐廳訂位紀錄資料
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(1,6,'2024-02-12','12:00:00',4,'已結單',3196);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(2,6,'2024-02-12','12:00:00',2,'已結單',1598);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(3,6,'2024-02-14','19:00:00',6,'已結單',5394);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(2,6,'2024-02-16','19:00:00',2,'已結單',1798);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(4,6,'2024-02-16','19:00:00',4,'已結單',3596);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(1,6,'2024-02-20','19:00:00',4,'已結單',3596);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(3,6,'2024-02-26','20:00:00',4,'已結單',3596);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(7,6,'2024-02-26','13:00:00',6,'已結單',4794);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(8,6,'2024-03-02','13:00:00',6,'已結單',4794);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(3,6,'2024-03-02','13:00:00',4,'已結單',3196);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(2,6,'2024-03-02','19:00:00',4,'已結單',3596);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(1,6,'2024-03-10','12:00:00',4,'已結單',3196);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(7,6,'2024-03-12','19:00:00',4,'已結單',3596);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(2,6,'2024-03-18','19:00:00',2,'已結單',1798);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(1,6,'2024-03-18','19:00:00',2,'已結單',1798);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(5,6,'2024-03-20','19:00:00',6,'已結單',5394);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(1,6,'2024-03-22','12:00:00',4,'已結單',3196);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(1,6,'2024-03-22','12:00:00',4,'已結單',3196);

insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(2,7,'2024-03-10','19:00:00',2,'已結單',1798);
insert into restaurantreserve(member_id,restaurant_id,reserveday,reservetime ,customer ,reservedstate,amount)values(1,7,'2024-03-12','19:00:00',2,'已結單',1798);
go


insert into restaurantckeditor(html,restaurant_id)values('<h3>&nbsp; 火炙炭烤坊</h3><h3>&nbsp; ﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊</h3><p>&nbsp; &nbsp;餐廳專線:0912345678</p><h3>｜營業時間｜</h3><p><br>&nbsp; &nbsp;午 &nbsp; &nbsp;間：11:00~13:30&nbsp;<br>&nbsp; &nbsp;下午茶：14:00~16:30<br>&nbsp; &nbsp;晚 &nbsp; &nbsp;間：18:00~21:00</p><h3>｜時段價位｜</h3><p>&nbsp; &nbsp;午 間 價 位 ：$899/位<br>&nbsp; &nbsp;下午茶價位：$799/位<br>&nbsp; &nbsp;晚 間 價 位 ：$999/位</p><h3>｜訂位規則｜</h3><ol><li>線上訂位僅開放部份座位及時段，部份保留電話及當日現場候位</li><li>當日用餐座位由現場人員依照當日營運狀況予以安排，恕無法選位，若有任何特殊需求（指定桌號、包廂）請電洽服務人員</li></ol><h3>｜溫馨提醒消費須知｜</h3><p>&nbsp; &nbsp;．訂位將保留10分鐘，逾時不候，接受現金<br>&nbsp; &nbsp;．用餐時間 90 分鐘 （ 1.5小時 ）<br>&nbsp; &nbsp;．自備酒水須著收開瓶費，烈酒 $1000／瓶；紅白酒 $500／瓶，若在本餐廳點一瓶酒，即可抵免一瓶開瓶費。<br>&nbsp; &nbsp;．店內用餐需酌收 10% 服務費</p><h3>｜停車場｜</h3><p>&nbsp; &nbsp;貴賓可至地下停車場停車，消費可折抵停車費。</p><p>&nbsp; &nbsp;如欲知詳情，臉書粉絲專頁或來電洽詢</p>',6)
insert into restaurantckeditor(html,restaurant_id)values('<h3>&nbsp; 滋味餐廳</h3><h3>&nbsp; ﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊</h3><p>&nbsp; &nbsp;餐廳專線:0912345672</p><h3>｜營業時間｜</h3><p><br>&nbsp; &nbsp;午 &nbsp; &nbsp;間：10:30~13:00&nbsp;<br>&nbsp; &nbsp;下午茶：14:00~16:30<br>&nbsp; &nbsp;晚 &nbsp; &nbsp;間：18:00~22:00</p><h3>｜時段價位｜</h3><p>&nbsp; &nbsp;午 間 價 位 ：$999/位<br>&nbsp; &nbsp;下午茶價位：$799/位<br>&nbsp; &nbsp;晚 間 價 位 ：$1399/位</p><h3>｜訂位規則｜</h3><ol><li>線上訂位僅開放部份座位及時段，部份保留電話及當日現場候位</li><li>當日用餐座位由現場人員依照當日營運狀況予以安排，恕無法選位，若有任何特殊需求（指定桌號、包廂）請電洽服務人員</li></ol><h3>｜溫馨提醒消費須知｜</h3><p>&nbsp; &nbsp;．訂位將保留10分鐘，逾時不候，接受現金<br>&nbsp; &nbsp;．用餐時間 90 分鐘 （ 1.5小時 ）<br>&nbsp; &nbsp;．店內用餐需酌收 10% 服務費</p><h3>｜停車場｜</h3><p>&nbsp; &nbsp;貴賓可至地下停車場停車，消費可折抵停車費。</p><p>&nbsp; &nbsp;如欲知詳情，臉書粉絲專頁或來電洽詢</p>',7);
insert into restaurantckeditor(html,restaurant_id)values('<h3>素味軒</h3><h3>&nbsp; ﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊</h3><p>&nbsp; &nbsp;餐廳專線:0912345678</p><h3>｜營業時間｜</h3><p><br>&nbsp; &nbsp;早 &nbsp; &nbsp;上：08:00~10:30&nbsp;<br>&nbsp; &nbsp;中 &nbsp; &nbsp;午：11:00~14:00<br>&nbsp; &nbsp;晚 &nbsp; &nbsp;上：18:00~21:00</p><h3>｜時段價位｜</h3><p>&nbsp; &nbsp;早 上 價 位 ：$499/位<br>&nbsp; &nbsp;中 午 價 位 ：$599/位<br>&nbsp; &nbsp;晚 間 價 位 ：$699/位</p><h3>｜訂位規則｜</h3><ol><li>線上訂位僅開放部份座位及時段，部份保留電話及當日現場候位</li><li>當日用餐座位由現場人員依照當日營運狀況予以安排，恕無法選位，若有任何特殊需求（指定桌號、包廂）請電洽服務人員</li></ol><h3>｜溫馨提醒消費須知｜</h3><p>&nbsp; &nbsp;．訂位將保留10分鐘，逾時不候，接受現金<br>&nbsp; &nbsp;．用餐時間 90 分鐘 （ 1.5小時 ）</p><h3>｜停車場｜</h3><p>&nbsp; &nbsp;貴賓可至地下停車場停車，消費可折抵停車費。</p><p>&nbsp; &nbsp;如欲知詳情，臉書粉絲專頁或來電洽詢</p>',8);
insert into restaurantckeditor(html,restaurant_id)values('<h3>綠蔬堂</h3><h3>&nbsp; ﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊</h3><p>&nbsp; &nbsp;餐廳專線:0912345678</p><h3>｜營業時間｜</h3><p><br>&nbsp; &nbsp;午 &nbsp; &nbsp;間：11:00~13:30&nbsp;<br>&nbsp; &nbsp;晚 &nbsp; &nbsp;間：17:00~20:00</p><h3>｜時段價位｜</h3><p>&nbsp; &nbsp;午 間 價 位 ：$599/位<br>&nbsp; &nbsp;晚 間 價 位 ：$699/位</p><h3>｜訂位規則｜</h3><ol><li>線上訂位僅開放部份座位及時段，部份保留電話及當日現場候位</li><li>當日用餐座位由現場人員依照當日營運狀況予以安排，恕無法選位，若有任何特殊需求（指定桌號、包廂）請電洽服務人員</li></ol><h3>｜溫馨提醒消費須知｜</h3><p>&nbsp; &nbsp;．訂位將保留10分鐘，逾時不候，接受現金<br>&nbsp; &nbsp;．用餐時間 90 分鐘 （ 1.5小時 ）</p><h3>｜停車場｜</h3><p>&nbsp; &nbsp;貴賓可至附近公有公園，免費停車格停車。</p><p>&nbsp;</p>',9);
insert into restaurantckeditor(html,restaurant_id)values('<h3>意式風情</h3><h3>&nbsp; ﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊﹊</h3><p>&nbsp; &nbsp;餐廳專線:0912345678</p><h3>｜營業時間｜</h3><p><br>&nbsp; &nbsp;午 &nbsp; &nbsp;間：11:30~14:30&nbsp;<br>&nbsp; &nbsp;晚 &nbsp; &nbsp;間：18:00~22:00</p><h3>｜時段價位｜</h3><p>&nbsp; &nbsp;午 間 價 位 ：$799/位<br>&nbsp; &nbsp;晚 間 價 位 ：$999/位</p><h3>｜訂位規則｜</h3><ol><li>線上訂位僅開放部份座位及時段，部份保留電話及當日現場候位</li><li>當日用餐座位由現場人員依照當日營運狀況予以安排，恕無法選位，若有任何特殊需求（指定桌號、包廂）請電洽服務人員</li></ol><h3>｜溫馨提醒消費須知｜</h3><p>&nbsp; &nbsp;．訂位將保留10分鐘，逾時不候，接受現金<br>&nbsp; &nbsp;．用餐時間 90 分鐘 （ 1.5小時 ）</p><h3>｜停車場｜</h3><p>&nbsp; &nbsp;貴賓可至地下停車場停車，消費可折抵停車費。</p>',10);
go

-- 外送員資料
insert into [iSpanProject].[dbo].[courier](email, password, salt, name,	phone, status, online_status, photo, registeration_date, longitude, latitude)values('courier1@gmail.com','password1','salt1','user1','09467821','1','1',0x111111111111111,'2021-03-01',120.301072, 22.637655)
insert into [iSpanProject].[dbo].[courier](email, password, salt, name,	phone, status, online_status, photo, registeration_date, longitude, latitude)values('courier2@gmail.com','password2','salt2','user2','09467821','1','1',0x111111111111110,'2021-03-02',120.310791, 22.619801)
insert into [iSpanProject].[dbo].[courier](email, password, salt, name,	phone, status, online_status, photo, registeration_date, longitude, latitude)values('courier3@gmail.com','password3','salt3','user3','09467821','1','1',0x111111111111101,'2021-03-03',120.308927, 22.624165)
insert into [iSpanProject].[dbo].[courier](email, password, salt, name,	phone, status, online_status, photo, registeration_date, longitude, latitude)values('courier4@gmail.com','password4','salt4','user4','09467821','1','1',0x111111111111100,'2021-03-04',120.323479, 22.633649)
insert into [iSpanProject].[dbo].[courier](email, password, salt, name,	phone, status, online_status, photo, registeration_date, longitude, latitude)values('courier5@gmail.com','password5','salt5','user5','09467821','1','1',0x111111111111011,'2021-03-05',120.299720, 22.635904)
insert into [iSpanProject].[dbo].[courier](email, password, salt, name,	phone, status, online_status, photo, registeration_date, longitude, latitude)values('courier6@gmail.com','password6','salt6','user6','09467821','1','1',0x111111111111010,'2021-03-06',120.294291, 22.635263)
go

-- 管理員假資料
insert into [iSpanProject].[dbo].[admin](email, password, salt, name, status)values('adminAccount1','jHucrk6sT5iK++xyVvmaKsoac8fJXln7DtQbHHYEmZA=','K7Q6NwXy+ufWhIt5wdeAuQ==','Admin1','1')
insert into [iSpanProject].[dbo].[admin](email, password, salt, name, status)values('adminAccount2','c+zrR9SBUNopacVKmi7raI1AdUIWJHfPH2USfjVQfDg=','VD6RhpGksq+h4hcXJFE05A==','Admin2','1')
insert into [iSpanProject].[dbo].[admin](email, password, salt, name, status)values('adminAccount3','SSBV4wj1Zxb89OtELfEVcIyDttXPouGRc9xTNhKrpPs=','s5ToucI3LJi+Ai12/r4vhA==','Admin3','1')
insert into [iSpanProject].[dbo].[admin](email, password, salt, name, status)values('adminAccount4','Q9iKpNH5Z+FUD3VPWsY0LHlEm7oFw0iT+besXNI09NQ=','GADzfHJRyEMQo4/046hjxw==','Admin4','1')
insert into [iSpanProject].[dbo].[admin](email, password, salt, name, status)values('adminAccount5','7DiAzure6+znZZrCsBxBgHrerU1mtxHCC14frNvx0wo=','MWAhRoXW0ytO5tJyk2GS5Q==','Admin5','1')
insert into [iSpanProject].[dbo].[admin](email, password, salt, name, status)values('adminAccount6','lA2MVw/R8J3x2TCzHgkoetM4mVmng1d/K4Qhp6xTI2E=','ordBFgNeyxz81f/DJOJPiQ==','Admin6','1')
go

-- 聯絡表單資料
insert into contactadmin(name,email,contenttext,status,created_time)values('jack','ispantest02@gmail.com','謝謝客服','finish','2024-03-14 12:00:00')
insert into contactadmin(name,email,contenttext,status,created_time)values('mary','ispantest02@gmail.com','很棒的購物體驗','finish','2024-03-15 12:00:00')
insert into contactadmin(name,email,contenttext,status,created_time)values('mike','ispantest02@gmail.com','很優惠的網站','finish','2024-03-16 12:00:00')

-- 回復聯絡表單資料
insert into reply(contactadmin_id,email,contenttext,reply_time)values('1','ispantest02@gmail.com','finish','2024-03-14 12:00:00')
insert into reply(contactadmin_id,email,contenttext,reply_time)values('2','ispantest02@gmail.com','finish','2024-03-14 12:00:00')
insert into reply(contactadmin_id,email,contenttext,reply_time)values('3','ispantest02@gmail.com','finish','2024-03-14 12:00:00')

-- 餐點資料
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 1, '鴨肉飯', 90, '煙燻鴨肉飯', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food2.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 1, '炭烤牛排', 500, '特選肋眼牛排，佐紅酒醬，肉質軟嫩油花分布均勻', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food3.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 1, '生菜沙拉', 120, '每日產地直送新鮮生菜與水果', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food4.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 1, '沙茶羊肉', 100, '每日溫體羊肉產地直送，搭配自製沙茶醬大火爆炒', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food5.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 1, '嫩煎鴨胸', 300, '特選宜蘭櫻桃鴨，小火慢煎，帶給您彈牙口感', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food6.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 1, '古早味米糕套餐', 100, '米糕搭配滷製排骨，附上一碗配料豐富的味噌湯', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food7.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo)SELECT 1, '霜降牛肉火鍋', 800, '油花分布均衡的頂級霜降牛肉，川燙5秒即能享受，濃厚的牛肉風味您不可錯過', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food8.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo)SELECT 1, '紅燒牛肉麵', 150, '正宗川辣牛肉麵，厚實牛腱肉與牛筋，搭配微辣口味的湯頭', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo)SELECT 1, '咖哩豬排飯', 180, '日式濃厚咖哩風味，軟嫩腰內豬排部位', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food10.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo)SELECT 1, '薯條', 30, '現炸馬鈴薯薯條，最佳點心小物選擇', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food11.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo)SELECT 1, '海鮮鍋燒意麵', 90, '豐富配料如蝦子、蛤蜊與豬肉，一碗熱騰騰的麵就能帶給您海陸饗宴', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food12.jpg', SINGLE_BLOB) AS img;

INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 2, '濃厚豚骨拉麵', 200, '道地日本口味豚骨拉麵，濃厚湯頭採用豬背脂熬製，入口綿密的叉燒肉更是畫龍點睛的存在', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food1.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 2, '叉燒大滿足拉麵', 200, '叉燒大滿足，多種部位的叉燒品項，帶給您感官與味覺雙重享受', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food14.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 2, '雞濃湯拉麵', 200, '每日限量30碗的雞濃湯拉麵，使用大量雞骨架熬製12小時而成', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food15.jpg', SINGLE_BLOB) AS img;

INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 3, '唐揚雞咖哩飯', 200, '咖哩採用8種辛香料與蔬果熬製，唐揚雞腿肉皮薄汁多', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food16.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 3, '打拋豬肉飯', 120, '肥瘦比1:3的豬絞肉，佐以微辣微酸的打拋醬汁，搭配半熟蛋', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food17.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 3, '海鮮蝦餅', 150, '豐富餡料包含新鮮白蝦、花枝、小卷，並以薄薄一層蛋液包裹，絕對是唰嘴的創意菜餚', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food18.jpg', SINGLE_BLOB) AS img;

INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 4, '4oz厚牛起司漢堡', 80, '每日手打牛肉漢堡排，淋上自製烤肉醬，麵包使用奶油煎烤增添香味', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food20.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 4, '卡拉雞腿漢堡', 65, '酥炸卡拉雞腿肉，皮薄肉汁豐富，搭配新鮮番茄中和炸物的油膩感', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food21.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 4, '黃金鱈魚漢堡', 55, '鱈魚排搭配新鮮小黃瓜與生菜，淋上酸甜黃芥末醬', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food22.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 4, '豬肉潛艇堡', 60, '本土豬肉，佐以獨家醬料醃製', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food23.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 4, '花生焦糖厚片', 40, '濃厚有顆粒的花生醬，搭配焦糖脆化口感，快來品嘗甜上加甜的滋味', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food24.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 4, '薯餅蛋餅', 45, '蛋餅夾著金黃酥脆的薯餅，口感兼具柔軟與酥脆', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food25.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 4, '煎餃', 40, '焦黃的外皮，豬肉內餡口感扎實', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food26.jpg', SINGLE_BLOB) AS img;
INSERT INTO menu (restaurant_id, name, price, description, photo) SELECT 4, '麥克雞塊', 35, '皮薄香酥的口感，最佳點心小物', BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food27.jpg', SINGLE_BLOB) AS img;
go

--優惠卷假資料
insert into coupon values('a8dz','birthday',0.5,1000,'2024-03-19 15:30:00','2024-04-03 15:30:00');
insert into coupon values('fg7a','newmember',0.65,2000,'2024-03-19 08:20:00','2024-04-03 09:30:00');
insert into coupon values('z96g','newyear',0.8,3000,'2024-03-19 10:20:00','2024-04-03 11:18:00');
insert into coupon values('y1wa','newyear',0.8,3000,'2024-03-19 10:20:00','2024-04-03 15:35:00');
go

--優惠卷會員關聯假資料
INSERT INTO member_coupon(member_id,coupon_id) VALUES (1,1);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (1,2);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (1,3);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (2,1);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (2,2);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (2,3);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (3,1);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (6,1);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (6,2);
INSERT INTO member_coupon(member_id,coupon_id) VALUES (7,1);
go
--廣告假資料
INSERT INTO ad_data (restaurant_id, location, photo, url, content, days, price, start_time, end_time, status, created_time) SELECT 1, 'A1', BulkColumn,'https://www.superman.specialties2008.com/', '炒飯買二送一 只有三天', 3, 9000,'2024-03-25 12:00:00', '2024-03-28 12:00:00', 'nocheck', '2024-03-25 12:00:00'FROM OPENROWSET(BULK 'C:\restaurantImage\炒飯.jpg', SINGLE_BLOB) AS pic;
INSERT INTO ad_data (restaurant_id, location, photo, url, content, days, price, start_time, end_time, status, created_time) SELECT 1, 'A1', BulkColumn,'https://guide.michelin.com/tw/zh_TW/tainan-region/tainan/restaurant/a-hsing-congee', '鹹粥內用免費 只有兩天', 2, 6000,'2024-03-25 12:00:00', '2024-03-26 12:00:00', 'nocheck', '2024-03-25 12:00:00'FROM OPENROWSET(BULK 'C:\restaurantImage\鹹粥.jpg', SINGLE_BLOB) AS pic;
INSERT INTO ad_data (restaurant_id, location, photo, url, content, days, price, start_time, end_time, status, created_time) SELECT 6, 'A1', BulkColumn,'https://www.foodvip.tw/zh-tw', '擔擔麵特價20元 三天優惠', 7, 9000,'2024-03-25 12:00:00', '2024-03-28 12:00:00', 'nocheck', '2024-03-25 12:00:00'FROM OPENROWSET(BULK 'C:\restaurantImage\擔擔麵.jpg', SINGLE_BLOB) AS pic;
go

-- 商城商品分類資料
INSERT INTO product_category (product_category)
VALUES
  ('食品飲料'),('冷凍商品'),('冷藏生鮮'),('即食美味'),('農產特產'),('健康保健'),('電子產品'),('家居用品'),('服飾配件'),('美妝護理'),('運動休閒'),('書籍雜誌'),('玩具遊戲'),('寵物用品'),('家電家具'),('手機配件'),('電腦硬體'),('鞋包配件'),('音樂樂器'),('生活用品'),('手作藝品'),('文具禮品'),('旅遊行李'),('辦公用品'),('戶外活動'),('視聽設備'),('家庭保養'),('婚禮用品'),('手錶配飾'),('汽機車零件'),('餐廚用品'),('戶外休閒'),('寵物食品'),('嬰幼用品'),('保險金融'),('工業用品'),('DIY材料'),('汽車交通'),('新奇特產'),('電競周邊'),('手作材料'),('電影音樂');

GO

--商城商品資料
-- product_category_id = 1
INSERT INTO product (restaurant_id, product_category_id, product_name, product_price, product_description, shelf_time, product_status, audit_status, inventory_quantity, photo)
VALUES 
(1, 1, '厚切大比目魚(扁鱈)', 300, '多種台灣茶葉混合禮盒，送禮佳品', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/fish9.jpg', SINGLE_BLOB) AS img)),
(2, 1, '手工基隆現撈小卷', 500, '精緻手工製作的餅乾禮盒，多種口味', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/小卷.webp', SINGLE_BLOB) AS img)),
(3, 1, '三好芋香米', 180, '新鮮水果製成的特製果醬，口味多樣', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/三好芋香米.jpg', SINGLE_BLOB) AS img)),
(1, 1, '台灣之光194好米', 400, '來自高山地區的頂級茶葉禮盒', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/台灣之光194好米.jpg', SINGLE_BLOB) AS img)),
(2, 1, '京都丹後特等米', 350, '手工製作的精緻巧克力禮盒，適合情人節', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/京都丹後特等米.jpg', SINGLE_BLOB) AS img)),
(3, 1, 'KitKat復活節巧克力', 280, '多種風味的精選咖啡豆', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/dairycho11.webp', SINGLE_BLOB) AS img)),
(1, 1, '蜂國蜂蜜驗證荔枝蜜', 220, '天然野生蜂蜜禮盒，健康飲食的首選', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/honey.png', SINGLE_BLOB) AS img)),
(2, 1, '復活節小白兔', 180, '各式特色口味的糖果禮盒，適合小孩', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/easterrabbit2.webp', SINGLE_BLOB) AS img)),
(3, 1, '莫札瑞拉起司香濃披薩', 320, '多種新鮮水果榨成的果汁禮盒', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/pizzaau1.jpeg', SINGLE_BLOB) AS img)),
(1, 1, '維多莉雅莊園紅酒', 500, '精選優質紅酒組合禮盒，適合送禮', GETDATE(), 1, 1, 30, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/wine.jpg', SINGLE_BLOB) AS img)),
(2, 1, '藝術家咖啡茶包禮盒', 1331, '多種風味的特色茶包組合，讓你品嚐不同', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/藝術家咖啡茶禮盒.png', SINGLE_BLOB) AS img)),
(3, 1, '盛香珍 禮讚堅果禮盒', 380, '各種健康堅果組合禮盒，營養豐富', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/盛香珍禮讚堅果禮盒.jpg', SINGLE_BLOB) AS img)),
(1, 1, '綜合果乾', 220, '各種口味的綜合乾果禮盒，健康零嘴', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/綜合果乾.webp', SINGLE_BLOB) AS img)),
(1, 1, '果香漫饗禮盒【果香茶韻】', 300, '多種台灣茶葉混合禮盒，送禮佳品', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/果香漫饗禮盒【果香茶韻】.webp', SINGLE_BLOB) AS img)),
(2, 1, '野生一口烏典藏禮盒(200g)', 250, '精緻手工製作的餅乾禮盒，多種口味', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/野生一口烏典藏禮盒(200g).jpg', SINGLE_BLOB) AS img)),
(3, 1, '法國精品傳統果醬禮盒組', 180, '新鮮水果製成的特製果醬，口味多樣', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/法國精品傳統果醬禮盒組.webp', SINGLE_BLOB) AS img)),
(1, 1, '高山茶禮盒', 400, '來自高山地區的頂級茶葉禮盒', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/高山茶禮盒.webp', SINGLE_BLOB) AS img)),
(2, 1, 'Cona’s星座巧克力', 350, '手工製作的精緻巧克力禮盒，適合情人節', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/Cona’s星座巧克力.jpeg', SINGLE_BLOB) AS img)),
(3, 1, '蜜香綜合水果乾', 280, '各種口味的綜合乾果禮盒，健康零嘴', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/蜜香綜合水果乾.webp', SINGLE_BLOB) AS img)),
(1, 1, '【蜜蜂工坊】金選台灣蜂蜜', 220, '天然野生蜂蜜禮盒，健康飲食的首選', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/【蜜蜂工坊】金選台灣蜂蜜.webp', SINGLE_BLOB) AS img)),
(2, 1, 'Mövenpick特濃咖啡豆500g', 180, '多種風味的精選咖啡豆', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/義大利特濃咖啡豆500g.jpeg', SINGLE_BLOB) AS img)),



(3, 1, '果汁', 320, '多種新鮮水果榨成的果汁禮盒', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/fish9.jpg', SINGLE_BLOB) AS img)),
(1, 1, '紅酒', 500, '精選優質紅酒組合禮盒，適合送禮', GETDATE(), 1, 1, 30, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/fish9.jpg', SINGLE_BLOB) AS img)),
(2, 1, '特色茶包組合', 150, '多種風味的特色茶包組合，讓你品嚐不同', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/imagesmall/fish9.jpg', SINGLE_BLOB) AS img)),
(3, 1, '健康堅果禮盒', 280, '各種健康堅果組合禮盒，營養豐富', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 1, '綜合乾果', 220, '各種口味的綜合乾果禮盒，健康零嘴', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 1, '精選花茶', 180, '多種花草植物製成的精選花茶禮盒', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 1, '特色餅乾', 250, '多種特色口味的餅乾禮盒，伴手禮首選', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 1, '特製沙拉醬組合', 180, '多種風味的特製沙拉醬組合，健康美味', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 1, '特色果醬', 200, '各式特色水果製成的果醬禮盒，多種用途', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 1, '精選茶葉', 300, '多種精選茶葉組合禮盒，品質保證', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 1, '特色蜜餞', 250, '多種特色蜜餞禮盒，甜品佳品', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 1, '單品咖啡豆', 280, '多種風味的咖啡豆組合禮盒，享受品嚐', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img));



-- product_category_id = 2
INSERT INTO product (restaurant_id, product_category_id, product_name, product_price, product_description, shelf_time, product_status, audit_status, inventory_quantity, photo)
VALUES 
(1, 2, '冷凍海鮮拼盤', 350, '多種新鮮海鮮拼盤，方便解凍即食', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 2, '冷凍肉品組合', 300, '多種優質肉品組合，方便保存和使用', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 2, '精選冷凍水餃', 180, '多種口味的精選水餃，方便烹調', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 2, '冷凍麵食套餐', 200, '多種口味的冷凍麵食套餐，美味便利', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 2, '冷凍火鍋料理', 250, '多種風味的火鍋料理，方便熱鍋即食', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 2, '冷凍餃子拼盤', 220, '多種風味的冷凍餃子拼盤，美味可口', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 2, '冷凍壽司組合', 300, '多種風味的壽司組合，方便享用', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 2, '冷凍漢堡套餐', 180, '多種口味的冷凍漢堡套餐，快速美味', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 2, '冷凍燒烤拼盤', 350, '多種風味的冷凍燒烤拼盤，方便烹調', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 2, '冷凍便當套餐', 250, '多種風味的冷凍便當套餐，方便美味', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 2, '冷凍麵條組合', 200, '多種口味的冷凍麵條組合，快速烹調', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 2, '冷凍燉飯套餐', 280, '多種口味的冷凍燉飯套餐，方便加熱', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 2, '瑪格麗特披薩', 250, '特製醬料搭配上新鮮食材的瑪格莉特起司披薩', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 2, '即食手工漢堡', 180, '經典美式風味的手工漢堡', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 2, '冷凍水餃組合', 180, '多種口味的冷凍水餃組合，方便烹調', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 2, '冷凍麵包組合', 250, '多種風味的冷凍麵包組合，方便取用', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 2, '冷凍餐盒組合', 200, '多種口味的冷凍餐盒組合，方便加熱', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 2, '冷凍漢堡組合', 280, '多種口味的冷凍漢堡組合，方便烹調', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 2, '冷凍麵食組合', 320, '多種口味的冷凍麵食組合，方便加熱', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 2, '冷凍三明治套餐', 180, '多種口味的冷凍三明治套餐，方便取用', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 2, '冷凍雞塊組合', 250, '多種口味的冷凍雞塊組合，方便烹調', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img));


-- product_category_id = 3
INSERT INTO product (restaurant_id, product_category_id, product_name, product_price, product_description, shelf_time, product_status, audit_status, inventory_quantity, photo)
VALUES 
(1, 3, '新鮮牛奶', 60, '100%純天然新鮮牛奶', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 3, '優質雞蛋', 30, '健康營養的優質雞蛋', GETDATE(), 1, 1, 300, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 3, '新鮮豆腐', 40, '新鮮健康的豆腐，適合多種烹調', GETDATE(), 1, 1, 150, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 3, '時令蔬菜組合', 80, '時令新鮮蔬菜組合，營養豐富', GETDATE(), 1, 1, 250, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 3, '精選水果禮盒', 150, '多種精選新鮮水果組合禮盒', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 3, '有機米飯', 100, '有機栽培的健康米飯，營養豐富', GETDATE(), 1, 1, 180, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 3, '新鮮海鮮', 300, '多種新鮮海鮮，健康美味', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 3, '優質牛肉', 250, '優質新鮮牛肉，適合多種烹調', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 3, '新鮮家禽', 180, '新鮮健康的家禽肉品，適合燉煮', GETDATE(), 1, 1, 150, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 3, '時令水果', 120, '時令新鮮水果，多種口味', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 3, '健康鮮蔬組合', 200, '多種健康新鮮蔬菜組合，營養豐富', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 3, '精選肉品組合', 280, '多種優質肉品組合，方便選購', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 3, '新鮮奶製品', 180, '多種新鮮奶製品，營養豐富', GETDATE(), 1, 1, 150, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 3, '精選海鮮組合', 350, '多種精選新鮮海鮮組合，美味多樣', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 3, '優質豬肉', 200, '優質新鮮豬肉，適合多種烹調', GETDATE(), 1, 1, 130, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 3, '新鮮蔬果組合', 250, '多種新鮮蔬菜水果組合，營養豐富', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 3, '有機蔬菜', 150, '有機栽培的健康蔬菜，營養豐富', GETDATE(), 1, 1, 180, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 3, '新鮮禽肉', 220, '新鮮健康的禽肉，多種口味', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 3, '新鮮蛋品', 80, '新鮮健康的蛋品，營養豐富', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 3, '精選牛肉組合', 300, '多種優質牛肉組合，方便選購', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img));


-- product_category_id = 4
INSERT INTO product (restaurant_id, product_category_id, product_name, product_price, product_description, shelf_time, product_status, audit_status, inventory_quantity, photo)
VALUES 
(1, 4, '紅燒牛肉麵料理包', 150, '傳統台灣風味的紅燒牛肉麵真空料理包', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 4, '特製辣味披薩', 200, '特製辣味醬料搭配上新鮮食材的披薩', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 4, '香辣牛肉乾', 180, '香辣風味的香辣牛肉乾，下酒美味', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 4, '家常酸菜白肉鍋料理包', 220, '家常酸菜白肉鍋的真空料理包', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 4, '特製香腸披薩', 250, '特製香腸搭配上新鮮食材的披薩', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 4, '香辣豬肉乾', 160, '香辣風味的香辣豬肉乾，下酒美味', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 4, '蒜香烤雞料理包', 280, '蒜香風味的蒜香烤雞真空料理包', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 4, '特製海鮮披薩', 300, '特製海鮮搭配上新鮮食材的披薩', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 4, '香辣雞肉乾', 150, '香辣風味的香辣雞肉乾，下酒美味', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 4, '麻辣火鍋料理包', 350, '麻辣風味的麻辣火鍋真空料理包', GETDATE(), 1, 1, 30, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 4, '特製夏威夷披薩', 280, '特製夏威夷口味的披薩', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 4, '五香牛肉乾', 200, '五香風味的五香牛肉乾，下酒美味', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 4, '咖哩牛肉麵料理包', 320, '咖哩風味的咖哩牛肉麵真空料理包', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 4, '特製墨西哥披薩', 320, '特製墨西哥口味的披薩', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 4, '五香豬肉乾', 180, '五香風味的五香豬肉乾，下酒美味', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 4, '酸菜白肉鍋料理包', 300, '酸菜白肉鍋的真空料理包', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 4, '特製海鮮燒餅', 380, '特製海鮮口味的燒餅', GETDATE(), 1, 1, 60, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 4, '椒麻雞料理包', 280, '椒麻風味的椒麻雞真空料理包', GETDATE(), 1, 1, 70, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 4, '酸菜牛肉麵料理包', 340, '酸菜風味的酸菜牛肉麵真空料理包', GETDATE(), 1, 1, 40, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 4, '特製墨西哥玉米餅', 280, '特製墨西哥玉米餅', GETDATE(), 1, 1, 50, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img));


-- product_category_id = 5
INSERT INTO product (restaurant_id, product_category_id, product_name, product_price, product_description, shelf_time, product_status, audit_status, inventory_quantity, photo)
VALUES 
(1, 5, '山藥餅', 80, '新鮮山藥製成的餅乾，營養豐富', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 5, '新鮮花生', 50, '新鮮健康的花生，適合零嘴', GETDATE(), 1, 1, 300, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 5, '特色辣條', 40, '辣味風味的特色辣條，下酒佳品', GETDATE(), 1, 1, 150, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 5, '手工魚丸', 100, '精選新鮮魚肉製成的手工魚丸', GETDATE(), 1, 1, 250, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 5, '紫菜捲', 120, '新鮮海產紫菜捲，美味可口', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 5, '酥炸花枝', 180, '酥炸風味的酥炸花枝，下酒佳品', GETDATE(), 1, 1, 180, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 5, '五香腐乳', 60, '傳統五香風味的五香腐乳', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 5, '豆皮卷', 40, '新鮮豆皮製成的豆皮卷，美味健康', GETDATE(), 1, 1, 160, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 5, '脆皮魷魚', 200, '脆皮風味的脆皮魷魚，下酒佳品', GETDATE(), 1, 1, 90, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 5, '海帶芽', 80, '新鮮健康的海帶芽，營養豐富', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 5, '酥炸豆腐', 120, '酥炸風味的酥炸豆腐，下酒佳品', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 5, '酥炸小雞腿', 180, '酥炸風味的酥炸小雞腿，下酒佳品', GETDATE(), 1, 1, 150, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 5, '五香豆乾', 60, '傳統五香風味的五香豆乾', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 5, '烤花生', 50, '烤製的美味花生，香脆可口', GETDATE(), 1, 1, 180, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 5, '炸雞排', 200, '炸製的風味炸雞排，下酒佳品', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 5, '麻辣豆腐', 80, '麻辣風味的麻辣豆腐，下酒佳品', GETDATE(), 1, 1, 250, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 5, '脆皮香蕉', 120, '酥炸風味的脆皮香蕉，下酒佳品', GETDATE(), 1, 1, 130, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 5, '烤魷魚', 180, '烤製的風味烤魷魚，下酒佳品', GETDATE(), 1, 1, 160, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 5, '五香薯條', 60, '傳統五香風味的五香薯條', GETDATE(), 1, 1, 220, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 5, '炸魷魚圈', 100, '酥炸風味的炸魷魚圈，下酒佳品', GETDATE(), 1, 1, 180, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img));


-- product_category_id = 6
INSERT INTO product (restaurant_id, product_category_id, product_name, product_price, product_description, shelf_time, product_status, audit_status, inventory_quantity, photo)
VALUES 
(1, 6, '維他命膠囊', 120, '多種維他命的營養膠囊，補充營養', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 6, '保健食品組合', 200, '多種保健食品組合，維持健康', GETDATE(), 1, 1, 300, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 6, '葉黃素軟膠囊', 180, '葉黃素的營養軟膠囊，保護視力', GETDATE(), 1, 1, 150, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 6, '蛋白粉', 100, '高蛋白質的蛋白粉，增肌健身首選', GETDATE(), 1, 1, 250, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 6, '鈣片', 150, '補充鈣質的營養片，強化骨骼', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 6, '魚油膠囊', 80, '魚油的營養膠囊，促進心血管健康', GETDATE(), 1, 1, 180, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 6, '葉酸片', 60, '補充葉酸的營養片，促進健康', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 6, '膠原蛋白粉', 200, '膠原蛋白的營養粉，促進皮膚彈性', GETDATE(), 1, 1, 160, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 6, '蔓越莓軟膠囊', 180, '蔓越莓的營養膠囊，促進泌尿健康', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 6, '氨基酸膠囊', 120, '多種氨基酸的營養膠囊，補充能量', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 6, '礦物質片', 150, '補充礦物質的營養片，促進健康', GETDATE(), 1, 1, 180, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 6, '葡萄籽膠囊', 80, '葡萄籽的營養膠囊，促進心血管健康', GETDATE(), 1, 1, 250, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 6, '益生菌膠囊', 100, '多種益生菌的營養膠囊，促進腸道健康', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 6, '鋅片', 150, '補充鋅質的營養片，促進健康', GETDATE(), 1, 1, 120, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 6, '膠囊', 80, '多種維生素的營養膠囊，促進健康', GETDATE(), 1, 1, 200, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 6, '複方軟膠囊', 120, '多種營養成分的複方軟膠囊，促進健康', GETDATE(), 1, 1, 150, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 6, 'DHA軟膠囊', 180, 'DHA的營養軟膠囊，促進腦部健康', GETDATE(), 1, 1, 100, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(3, 6, '複合維他命片', 100, '多種維他命的營養片，促進健康', GETDATE(), 1, 1, 180, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(1, 6, '鉻膳食膠囊', 120, '鉻的膳食膠囊，促進新陳代謝', GETDATE(), 1, 1, 80, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img)),
(2, 6, '膠囊', 80, '多種維生素的營養膠囊，促進健康', GETDATE(), 1, 1, 150, (SELECT BulkColumn FROM OPENROWSET(BULK 'C:/restaurantImage/food9.jpg', SINGLE_BLOB) AS img));

GO

--商城訂單資料mall_order
INSERT INTO mall_order (member_id, order_total_amount, order_status, order_time, payment_time, shipping_time, shipping_address)
VALUES 
(1, 1000, 'CREATED', '2024-03-27 10:19:45', '2024-03-27 10:19:45', '2024-03-27 10:19:45', '123'),
(2, 1500, 'CREATED', '2024-03-27 11:25:30', '2024-03-27 11:25:30', '2024-03-27 11:25:30', '456'),
(3, 800, 'PAID', '2024-03-27 12:30:15', '2024-03-27 12:30:15', '2024-03-27 12:30:15', '789'),
(1, 2000, 'SHIPPED', '2024-03-27 13:35:00', '2024-03-27 13:35:00', '2024-03-27 13:35:00', '101112'),
(4, 1200, 'COMPLETED', '2024-03-27 14:40:45', '2024-03-27 14:40:45', '2024-03-27 14:40:45', '131415'),
(5, 900, 'CANCELED', '2024-03-27 15:45:30', '2024-03-27 15:45:30', '2024-03-27 15:45:30', '161718');

--商城訂單明細資料mall_order_detail
INSERT INTO mall_order_detail (order_id, product_id, product_price, quantity, order_time)
VALUES 
(1, 1, 500, 2, '2024-03-27 10:19:45'),
(2, 2, 750, 1, '2024-03-27 11:25:30'),
(3, 3, 400, 3, '2024-03-27 12:30:15'),
(4, 4, 600, 2, '2024-03-27 13:35:00'),
(5, 5, 450, 2, '2024-03-27 14:40:45');

--商城購物車資料mall_shopping_cart
INSERT INTO mall_shopping_cart (member_id, product_id, quantity, added_cart_time)
VALUES 
(1, 1, 2, '2024-03-27 10:19:45'),
(2, 2, 1, '2024-03-27 11:25:30'),
(1, 3, 3, '2024-03-27 12:30:15'),
(3, 4, 2, '2024-03-27 13:35:00'),
(1, 5, 2, '2024-03-27 14:40:45');
