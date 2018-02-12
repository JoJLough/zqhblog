<%@ page language="java" contentType="text/html; utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="background: #ffffff !important;">

<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/statics/plugins/editor.md/css/editormd.css"/>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/statics/plugins/jquery.validationEngine/validationEngine.jquery.css"/>

</head>

<body>

<div class="row">
    <div class="col-md-12">
        <div class="block-flat">
            <div class="header">
                <h3>Basic Elements</h3>
            </div>
            <div class="content">
                <form class="form-horizontal group-border-dashed" id="article-form" style="border-radius: 0px;">
                    <div class="form-group">
                        <label class="col-sm-1 control-label">博客标题</label>
                        <div class="col-sm-6">
                            <input type="text" class="form-control validate[required]" name="aTitle" id="aTitle" >
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-1 control-label">分类于</label>
                        <div class="col-sm-6">
                            <select class="select2" name="categorySn" id="categorySn">
                                <option value="0">暂不分类</option>
                                <c:forEach items="${categoryList}" var="list">
                                    <option value="${list.sn}">${list.CName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-1 control-label">概要</label>
                        <div class="col-sm-8">
                            <textarea class="form-control validate[required]" id="aSummary" name="aSummary"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-1 control-label">博客内容</label>
                        <div class="col-sm-11" id="test-editormd">
                            <textarea class="editormd-markdown-textarea" name="test-editormd-markdown-doc"
                                      id="editormd"></textarea>
                            <!-- 第二个隐藏文本域，用来构造生成的HTML代码，方便表单POST提交，这里的name可以任意取，后台接受时以这个name键为准 -->
                            <!-- html textarea 需要开启配置项 saveHTMLToTextarea == true -->
                            <textarea class="editormd-html-textarea" name="aContent" id="aContent"></textarea>
                        </div>
                    </div>

                </form>

                <div class="form-group">
                    <label class="col-sm-1 control-label"></label>
                    <button type="button" class="btn btn-primary" id="publish_blog">立即发布</button>
                    <button type="reset" class="btn btn-default" onclick="resetBlog()">重置</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/statics/plugins/editor.md/editormd.min.js"></script>
<%--校验框架--%>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/statics/plugins/jquery.validationEngine/jquery.validationEngine.min.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/statics/plugins/jquery.validationEngine/jquery.validationEngine-zh_CN.js"></script>

<script>
    //jquery.validate框架初始化
    $(function () {
        $("#article-form").validationEngine("attach", {scroll: false});
        App.init();

        //发布博客
        $("#publish_blog").click(function () {
            var flag = $("#article-form").validationEngine("validate");
            if (flag == false) {
                return;
            } else {
                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/bms/article/addSubmit.do",
                    data: {
                        "aTitle": $("#aTitle").val(),
                        "categorySn": $("#categorySn").val(),
                        "aSummary": $("#aSummary").val(),
                        "aContent": $("#aContent").val()
                    },
                    cache: false,
                    success: function (data) {
                        if (data == "success") {
                            layer.confirm('发布成功！赶快去看看吧', {
                                btn: ['去看看', '懒，不去'],
                                skin: 'layui-layer-lan',
                                anim: 4,
                                icon: 1
                            }, function (index) {
                                resetBlog();
                                layer.close(index);
                                window.open('${pageContext.request.contextPath}/index');
                            }, function (index) {
                                resetBlog();
                                layer.close(index);
                            });
                        } else {
                            layer.alert('发布失败', {
                                skin: 'layui-layer-lan',
                                closeBtn: 0,
                                nim: 4,
                                icon: 2
                            });
                        }
                    }
                });
            }
        });

    });

    function resetBlog() {
        $('#article-form')[0].reset();
        $('.fa-eraser').trigger('click');
    }

</script>

<script type="text/javascript">
    var testEditor;
    testEditor = $(function () {
        editormd("test-editormd", {
            width: false,
            height: 640,
            //markdown : md,
            codeFold: true,
            syncScrolling: "single",
            //你的lib目录的路径
            path: "${pageContext.request.contextPath}/statics/plugins/editor.md/lib/",
            imageUpload: false,//关闭图片上传功能
            //theme: "dark",//工具栏主题
            //previewTheme: "dark",//预览主题
            //editorTheme: "pastel-on-dark",//编辑主题
            emoji: true,
            taskList: true,
            tocm: true,         // Using [TOCM]
            tex: true,                   // 开启科学公式TeX语言支持，默认关闭
            flowChart: true,             // 开启流程图支持，默认关闭
            sequenceDiagram: true,       // 开启时序/序列图支持，默认关闭,
            //这个配置在simple.html中并没有，但是为了能够提交表单，使用这个配置可以让构造出来的HTML代码直接在第二个隐藏的textarea域中，方便post提交表单。
            saveHTMLToTextarea: true
        });
    });
</script>

</body>

</html>