import 'package:flutter/material.dart';
import 'package:mall/entity/project_selection_detail_entity.dart';
import 'package:mall/service/goods_service.dart';
import 'package:mall/widgets/futurebuilder_widget.dart';
import "package:flutter_html/flutter_html.dart";
import 'package:mall/constant/string.dart';
import 'package:mall/utils/toast_util.dart';
import 'package:mall/widgets/loading_dialog.dart';
import 'package:mall/widgets/network_error.dart';
import 'package:mall/entity/project_selection_recommed_entity.dart';
import "package:mall/utils/navigator_util.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectSelectionDetailView extends StatefulWidget {
  int id;

  ProjectSelectionDetailView(this.id);

  @override
  _ProjectSelectionDetailViewState createState() =>
      _ProjectSelectionDetailViewState();
}

class _ProjectSelectionDetailViewState
    extends State<ProjectSelectionDetailView> {
  GoodsService _goodsService = GoodsService();
  ProjectSelectionDetailEntity _projectSelectionDetailEntity;
  ProjectSelectionRecommedEntity _projectSelectionRecommedEntity;
  Future _future;

  @override
  void initState() {
    super.initState();
    _queryProjectSelection();
  }

  _queryProjectSelection() {
    var parameters = {"id": widget.id};
    _future = _goodsService.projectSelectionDetail(parameters, (success) {
      setState(() {
        _projectSelectionDetailEntity = success;
      });
    }, (error) {}).then((_) {
      _queryRecommed();
    });
  }

  _queryRecommed() {
    var parameters = {"id": widget.id};
    _goodsService.projectSelectionRecommend(parameters, (success) {
      setState(() {
        _projectSelectionRecommedEntity = success;
      });
    }, (error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.PROJECT_SELECTION_DETAIL),
          centerTitle: true,
        ),
        body: FutureBuilderWidget(_future, LoadingDialog(),
            NetWorkErrorView(_queryProjectSelection), _contentView()));
  }

  Widget _contentView() {
    return _projectSelectionDetailEntity != null &&
            _projectSelectionRecommedEntity != null
        ? Container(
            child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Html(
                    data: _projectSelectionDetailEntity.topic.content
                        .replaceAll("//", "http://")),
                Container(
                  height: 40.0,
                  alignment: Alignment.center,
                  child: Text(Strings.RECOMMEND_PROJECT_SELECTION,style: TextStyle(color: Colors.black54,fontSize: ScreenUtil.instance.setSp(26.0)),),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _projectSelectionRecommedEntity.recommed.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _itemView(
                          _projectSelectionRecommedEntity.recommed[index]);
                    })
              ],
            ),
          ))
        : LoadingDialog();
  }

  Widget _itemView(Recommed recommend) {
    return Container(
      width: ScreenUtil.instance.setWidth(600.0),
      child: Card(
        child: InkWell(
          onTap: () => _goDetail(recommend.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Image.network(
                  recommend.picUrl,
                  fit: BoxFit.cover,
                  width: ScreenUtil.instance.setWidth(600.0),
                  height: ScreenUtil.instance.setHeight(260.0),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil.instance.setHeight(10.0))),
              Container(
                  padding:
                      EdgeInsets.only(left: ScreenUtil.instance.setWidth(10.0)),
                  child: Text(
                    recommend.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: ScreenUtil.instance.setSp(26.0)),
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: ScreenUtil.instance.setHeight(6.0))),
              Container(
                  padding:
                      EdgeInsets.only(left: ScreenUtil.instance.setWidth(10.0)),
                  child: Text(
                    recommend.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: ScreenUtil.instance.setSp(26.0)),
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: ScreenUtil.instance.setHeight(6.0))),
              Container(
                  padding:
                      EdgeInsets.only(left: ScreenUtil.instance.setWidth(10.0)),
                  child: Text(
                    Strings.DOLLAR + "${recommend.price}",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: ScreenUtil.instance.setSp(26.0)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  _goDetail(int id) {
    NavigatorUtils.goProjectSelectionDetail(context, id,true);
  }
}
