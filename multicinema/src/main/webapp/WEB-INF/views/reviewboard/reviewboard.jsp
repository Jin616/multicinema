<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Review Board Dummy Data</title>
<link rel="stylesheet" type="text/css" href="resources/css/reviewboard/review.css">
<link rel="stylesheet" type="text/css" href="resources/css/reviewboard/header.css">
<script src="resources/js/jquery-3.7.1.min.js"></script>
</head>
<header class="body">
	<div class="header">
		<h1 class="mainlogo">
			<a href="main_signout.html" title="홈화면으로 가기">홈으로가기</a>
		</h1>
		<div class="myinformation">
			<a href="main_signin.html">로그인하기</a>
			<a href="signin.html">회원가입</a>
		</div>
	</div>
		
	<hr>
		<ul id="mainNavigator">
			<li id="movie"><a href="movie.html">영화</a></li>
			<li id="ticketing"><a href="tiketing.html">예매</a></li>
			<li id="theater"><a href="theater.html">영화관</a></li>
		</ul>
	<hr>
</header>
<body>

<div id="headerInput"></div>

<div>
	<div id="listOption" style="text-align: right">
		<select id="viewListOption">
			<option value="0">==2=====</option>
			<option value="10">10개씩 보기</option>
			<option value="20">20개씩 보기</option>
			<option value="50">50개씩 보기</option>
		</select>
	</div>
    <div id="reviewBoard">

    </div>
</div>

<script>
let limit;
let currentPage;

let createListTable = (list) => {
	let table = createTable("boardListTable");
    table.style.textAlign = "center";
    let tr = createTr();

    let thTextList = ["글번호", "영화", "글제목", "작성자", "작성일", "조회", "추천", "댓글"];
	let thIdList = ["thBno", "thMovieTitle", "thBoardTitle", "thWriter", "thWriteDay", "thViewCount", "thLikeCount", "thCommentCount"];
    for(let i = 0; i < thTextList.length; i++) {tr.append(createTh(thTextList[i], thIdList[i]))};

    table.append(tr);
    if(list.length > 0) {
        list.forEach(b => {
            let tr = createTr(b.board_num);
            tr.onmouseenter = function() {this.style.backgroundColor = "rgb(238, 238, 238)";}
		    tr.onmouseleave = function() {this.style.backgroundColor = "";}
            
            if(b.board_like_count >= 10) tr.style.fontWeight = "bold";
            
            tr.onclick = () => {window.location.href="/reviewdetail?board_num="+b.board_num};
			
            tr.append(createTd(b.board_num));
            tr.append(createTd(b.movie_cd));
            tr.append(createTd(b.board_title));
            tr.append(createTd(b.user_key));
            tr.append(createTd(b.board_write_date));
            tr.append(createTd(b.board_view_count));
            tr.append(createTd(b.board_like_count));
            tr.append(createTd(b.board_comment_count));
            table.append(tr);
        });
    }
    return table;
}



let createPagingMenu = (size) => {
    let div = createDiv("pagingMenu");
    let board_count;
    
    return div;
}

let createSelectSearchOption = () => {
    let div = createDiv("searchOption");



    return div;
}

window.onload = function() {
	
    let board = document.getElementById("reviewBoard");
    
    let urlParams = new URLSearchParams(window.location.search);
    limit = 10;
    currentPage = urlParams.get('page');
    
    $.ajax({
        url:"reviewboard",
        data:{'page':currentPage,'limit':limit},
        type:'get',
        success:function(list) {refreshBoard(list)},
        error:function(request, e) {loggingConsole(request, e)}
	});

	$("#viewListOption").on('change', function(e){
        let limit = $("#viewListOption").val();
        if(limit == 0)
            return ;

		currentPage = 1;
		$.ajax({
			url:"reviewboard",
			data:{'page':currentPage,'limit':limit},
			type:'get',
			success:function(list) {refreshBoard(list)},
			error:function(request, e) {loggingConsole(request, e)}
		});
	});

    let loggingConsole = (request, e) => {
        console.log("코드="+request.status + " 메시지=" + request.responseText + " 오류=" + e);
    }

    let refreshBoard = (list) => {
        board.innerHTML = "";
        board.append(createListTable(list));
        board.append(createPagingMenu(list.size()));
        board.append(createSelectSearchOption());
    }
}

// 기본요소들 생성
let createDiv = (id) => {
	let div = document.createElement("div");
	if(id !== undefined)
		div.id = id;
	return div;
}

let createSelect = (id, options) => {
	let select = document.createElement("select");
	select.id = id;
	
	for(let i = 0; i < options.length; i++)
		select.append(options[i]);
	return select;
}

let createOption = (value, text) => {
	let option = document.createElement("option");
	option.value = value;
	option.textContent = text;
	return option;
}

let createTable = (id) => {
	let table = document.createElement("table"); 
	if(id !== undefined)
		table.id = id;
	return table;
}

let createTbody = (id) => {
	let tbody = document.createElement("tbody");
	if(id !== undefined)
		tbody.id = id;
	return tbody;
}

let createTh = (text, id) => {
	let th = document.createElement("th");
	th.textContent = text;
	if(id !== undefined)
		th.id = id;
	return th;
}

let createTr = (id) => {
	let tr = document.createElement("tr");
	if(id !== undefined)
		tr.id = id;
	return tr;
}

let createTd = (text, id) => {
	let td = document.createElement("td");
	td.textContent = text;
	if(id !== undefined)
		td.id = id;
	return td;
}
</script>
<!-- <script src="resources/js//reviewboard/review_old.js"></script> -->

</body>

</html>