<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<title>工资薪金</title>
	<link rel="stylesheet" href="<%=basePath%>resources/layui/css/layui.css">
	<style>
		.layui-form-item{
			margin-top: 9px;
		}
		.layui-btn{
			border-radius: 5px;
		}
	</style>
</head>
<body>

<div style="margin: 1%;height: 843px">
	<!-- 内容主体区域 -->

	<div class="layui-form">
		<div class="layui-form-item">

			<label class="layui-form-label">支出类型：</label>
			<div class="layui-input-inline">
				<input type="text" name="insertGongZiType" id="insertGongZiType" lay-verify="required" placeholder="想一想支出明细是什么" autocomplete="off" class="layui-input">
			</div>

			<label class="layui-form-label">支出金额：</label>
			<div class="layui-input-inline">
				<input type="text" name="insertGongZiData" id="insertGongZiData" lay-verify="required" placeholder="想一想支出了多少钱" autocomplete="off" class="layui-input">
			</div>

			<label class="layui-form-label">支出时间：</label>
			<div class="layui-inline">
				<input type="text" class="layui-input" id="insertDATEYMD" placeholder="几号的支出呢" autocomplete="off">
			</div>
			<div class="layui-inline">
				<button type="button" class="layui-btn" onclick="insertGZData()">保存</button>
			</div>
		</div>
	</div>

	<div class="layui-form">
		<div class="layui-form-item">

			<div class="layui-inline">
				<label class="layui-form-label">选择时间：</label>
				<div class="layui-inline">
					<input type="text" class="layui-input" id="selectDateYMD" placeholder="想查几号鸭" autocomplete="off">
				</div>
				<div class="layui-inline">
					<button type="button" class="layui-btn" onclick="getGZDataByYMD()">走你</button>
				</div>
			</div>

			<div class="layui-inline">
				<label class="layui-form-label">选择时间：</label>
				<div class="layui-inline">
					<input type="text" class="layui-input" id="selectDateYM" placeholder="想查几月鸭" autocomplete="off">
				</div>
				<div class="layui-inline">
					<button type="button" class="layui-btn" onclick="getGZDataByYM()">走你</button>
				</div>
				<div class="layui-inline">
					<button type="button" class="layui-btn" onclick="getGZCountByYM()">来康康工资付了多少钱</button>
				</div>
				<div class="layui-inline">
					<button type="button" class="layui-btn" onclick="excelGongZiData()">导出支出数据</button>
				</div>
			</div>

			<div>
				<table class="layui-hide" id="test5"></table>
			</div>

		</div>
	</div>

	<div id="gongZiEcharts" style="width:100%;height:45%;margin-top: 1%">
	</div>

</div>

<script src="<%=basePath%>resources/layui/layui.all.js"></script>
<script src="<%=basePath%>resources/layui_exts/excel.js"></script>
<script src="<%=basePath%>resources/jquery/jquery-2.1.4.min.js"></script>
<script src="<%=basePath%>resources/echarts/echarts.js"></script>

<script type="text/javascript">
	var layer = layui.layer;
	var table = layui.table;
	var laydate = layui.laydate;

	$(function() {

		let date = new Date().getFullYear() + formatDateMonth(new Date().getMonth() + 1);
		getGZDataByYM_save(date);
	});

	function getGZDataByYMD(){

		let date =  $("#selectDateYMD").val();
		if(date == null || date == ''){

			layer.msg("要选择一个日期哦");
			return;
		}
		let dateYMD = formatDate(date);
		table.render({
			elem: '#test5',
			url: '<%=basePath%>getGongZiByMonthDay',
			where: {
				dateYMD
			},
			cellMinWidth: 80, //全局定义常规单元格的最小宽度，layui 2.2.1 新增
			method: 'post',
			cols: [[
				{field:'gongZi_name', title: '支出类型', align: 'center'},
				{field:'gongZi_money', title: '支出金额', sort: true, align: 'center'}, //width 支持：数字、百分比和不填写。你还可以通过 minWidth 参数局部定义当前单元格的最小宽度，layui 2.2.1 新增
				{field:'gongZi_time', title: '支出日期', align: 'center'},
			]]
		});
	};

	function getGZDataByYM(){

		let date =  $("#selectDateYM").val();

		if(date == null || date == ''){

			layer.msg("要选择一个日期哦");
			return;
		}
		let dateYM = formatDate(date);

		table.render({
			elem: '#test5',
			url: '<%=basePath%>getGongZiByMonth',
			where: {
				dateYM
			},
			cellMinWidth: 80, //全局定义常规单元格的最小宽度，layui 2.2.1 新增
			height: 350,
			method: 'post',
			cols: [[
				{field:'gongZi_name', title: '支出类型', align: 'center'},
				{field:'gongZi_money', title: '支出金额', sort: true, align: 'center'}, //width 支持：数字、百分比和不填写。你还可以通过 minWidth 参数局部定义当前单元格的最小宽度，layui 2.2.1 新增
				{field:'gongZi_time', title: '支出日期', align: 'center'},
			]]
		});

		// 基于准备好的dom，初始化echarts实例
		let myChart = echarts.init(document.getElementById('gongZiEcharts'));

		let echartsMoney = new Array();
		let echartsTime = new Array();
		$.ajax({
			async: false,
			type: "POST",
			url: "<%=basePath%>getGongZiByMonthEcharts",
			data:{
				"dateYM":dateYM
			},
			success: function(data){
				echartsMoney = data.echartsMoney;
				echartsTime = data.echartsTime;
			}
		});

		// 指定图表的配置项和数据
		let option = {
			tooltip : {
				trigger: 'axis',
				axisPointer: {
					type: 'none'
				}
			},
			title: {
				text: '支出走势柱状图',
			},
			color: ['#33ABA0'],
			xAxis: {
				type: 'category',
				data: echartsTime
			},
			yAxis: {
				type: 'value'
			},
			series: [{
				data: echartsMoney,
				type: 'bar'
			}]
		};

		// 使用刚指定的配置项和数据显示图表。
		myChart.setOption(option);
	};

	function getGZDataByYM_save(dateYM){

		table.render({
			elem: '#test5',
			url: '<%=basePath%>getGongZiByMonth',
			where: {
				dateYM
			},
			cellMinWidth: 80, //全局定义常规单元格的最小宽度，layui 2.2.1 新增
			height: 350,
			method: 'post',
			cols: [[
				{field:'gongZi_name', title: '工资明细', align: 'center'},
				{field:'gongZi_remark', title: '工资备注', align: 'center'},
				{field:'gongZi_money', title: '工资金额', sort: true, align: 'center'}, //width 支持：数字、百分比和不填写。你还可以通过 minWidth 参数局部定义当前单元格的最小宽度，layui 2.2.1 新增
				{field:'gongZi_time', title: '发放日期', align: 'center'},
			]]
		});

		// 基于准备好的dom，初始化echarts实例
		let myChart = echarts.init(document.getElementById('gongZiEcharts'));

		let echartsMoney = new Array();
		let echartsTime = new Array();
		$.ajax({
			async: false,
			type: "POST",
			url: "<%=basePath%>getGongZiByMonthEcharts",
			data:{
				"dateYM":dateYM
			},
			success: function(data){
				echartsMoney = data.echartsMoney;
				echartsTime = data.echartsTime;
			}
		});

		// 指定图表的配置项和数据
		let option = {
			tooltip : {
				trigger: 'axis',
				axisPointer: {
					type: 'none'
				}
			},
			title: {
				text: '工资走势柱状图',
			},
			color: ['#33ABA0'],
			xAxis: {
				type: 'category',
				data: echartsTime
			},
			yAxis: {
				type: 'value'
			},
			series: [{
				data: echartsMoney,
				type: 'bar'
			}]
		};

		// 使用刚指定的配置项和数据显示图表。
		myChart.setOption(option);
	};

	function insertGZData(){

		let insertGongZiType =  $("#insertGongZiType").val();
		let insertGongZiData =  $("#insertGongZiData").val();
		let insertDATEYMD =  formatDate($("#insertDATEYMD").val());
		if(insertGongZiType == null || insertGongZiType == ''){

			layer.msg("要填一个支出类型哦");
			return;
		}
		if(insertGongZiData == null || insertGongZiData == ''){

			layer.msg("金额是不是忘填了啊");
			return;
		}
		if(insertDATEYMD == null || insertDATEYMD == ''){

			layer.msg("要选择一个日期哦");
			return;
		}
		let params = {
			"insertGongZiType":insertGongZiType,
			"insertGongZiData":insertGongZiData,
			"insertDATEYMD":insertDATEYMD
		};
		$.ajax({
			//请求方式
			type : "POST",
			//请求的媒体类型
			contentType: "application/json;charset=UTF-8",
			//请求地址
			url : "<%=basePath%>insertGongZiData",
			//数据，json字符串
			data : JSON.stringify(params),
			//请求成功
			success : function(result) {
				if(result.status == "success"){
					insertDATEYMD = insertDATEYMD.substring(0,6);
					getGZDataByYM_save(insertDATEYMD);
					$("#insertGongZiType").val("");
					$("#insertGongZiData").val("");
					layer.msg("保存成功啦");
				}
			},
			//请求失败，包含具体的错误信息
			error : function(e){
				console.log(e.status);
				console.log(e.responseText);
			}
		});

	};

	function getGZCountByYM(){

		let date = $("#selectDateYM").val();
		if (date == null || date == '') {

			layer.msg("要选择一个日期哦");
			return;
		}
		let dateYM = formatDate(date);
		let params = {
			"dateYM":dateYM
		};
		$.ajax({
			//请求方式
			type : "POST",
			//请求的媒体类型
			contentType: "application/json;charset=UTF-8",
			//请求地址
			url : "<%=basePath%>getGZCountByYM",
			//数据，json字符串
			data : JSON.stringify(params),
			//请求成功
			success : function(result) {
				if(result.gongZiCount == null || result.gongZiCount == undefined){
					layer.msg("还没有花钱，开心~");
					return;
				}
				layer.alert(date+" "+"一共花了"+" "+result.gongZiCount+"~~~", {
					skin: 'layui-layer-molv',//样式类名
					closeBtn: 0
				});
			},
			//请求失败，包含具体的错误信息
			error : function(e){
				console.log(e.status);
				console.log(e.responseText);
			}
		});
	};

	function excelGongZiData(){

		let date =  $("#selectDateYM").val();

		if(date == null || date == ''){

			layer.msg("要选择一个日期哦");
			return;
		}

		let loading = layer.load();
		let dateYM = formatDate(date);

		layui.config({
			base: '<%=basePath%>resources/layui_exts/',
		}).extend({
			excel: 'excel',
		});

		let excel = layui.excel;

		let params = {
			"dateYM":dateYM
		};
		$.ajax({
			//请求方式
			type : "POST",
			//请求的媒体类型
			contentType: "application/json;charset=UTF-8",
			//请求地址
			url : "<%=basePath%>getGongZiByMonthExcel",
			//数据，json字符串
			data : JSON.stringify(params),
			//请求成功
			success(res) {
				let data = res.data;
				// 重点！！！如果后端给的数据顺序和映射关系不对，请执行梳理函数后导出
				data = excel.filterExportData(data, [
					'gongZi_name',
					'gongZi_money',
					'gongZi_time',
				]);
				// 重点2！！！一般都需要加一个表头，表头的键名顺序需要与最终导出的数据一致
				data.unshift({
					gongZi_name: "支出明细",
					gongZi_money: "支出金额",
					gongZi_time: "支出时间"
				});
				excel.exportExcel(data, date + " 支出明细" + ".xlsx", "xlsx");
				layer.close(loading);
				layer.msg("导出成功");
			},
			error() {
				layer.msg("导出失败");
			}
		});
		/*layui.use(['excel'], function() {

        });*/
	}

	function formatDate(date){

		let str = new String();
		let arr = new Array();
		arr = date.split('-');
		for(let i=0;i<arr.length;i++){
			str += arr[i];
		}

		return str
	};

	function formatDateMonth(date){

		let month = new String();
		if(date < 10){

			month = "0" + date;
			return month;
		}else{

			month = date;
			return month;
		}
	};

	//常规用法
	laydate.render({
		elem: '#insertDATEYMD',
		trigger: 'click', //采用click弹出
		position: 'fixed'
	});

	//常规用法
	laydate.render({
		elem: '#selectDateYMD',
		trigger: 'click'
	});

	//年月选择器
	laydate.render({
		elem: '#selectDateYM',
		/*value: new Date().,
        isInitValue: true,*/
		trigger: 'click',
		type: 'month'
	});
</script>
</body>
</html>