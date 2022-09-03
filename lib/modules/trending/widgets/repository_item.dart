import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/extensions/widget_nested.dart';
import 'package:flutter_boilerplate/common/utils/color_util.dart';
import 'package:trending_api/trending_api.dart';

class RepositoryItem extends StatefulWidget {
  final int index;
  final Trending trending;
  final bool last;

  const RepositoryItem({
    Key? key,
    required this.index,
    required this.trending,
    required this.last,
  }) : super(key: key);

  @override
  _RepositoryItemState createState() => _RepositoryItemState();
}

class _RepositoryItemState extends State<RepositoryItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 2),
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      decoration: BoxDecoration(
        border: Border(bottom: widget.last ? BorderSide.none : BorderSide(width: 0.2)),
      ),
      child: [
        avatarImage(),
        [
          _content(),
          _numberIndex,
        ].nestedStack().nestedExpanded()
      ].nestedRow(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget avatarImage() {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: CircleAvatar(
        radius: 12,
        child: Image.network(widget.trending.avatar, width: 24, height: 24,),
      ),
    );
  }

  Widget _content() {
    return [
      _title,
      _description,
      _buildBy(context),
      _languageBanner,
    ]
        .nestedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    )
        .nestedPadding(
      padding: const EdgeInsets.only(left: 10, right: 4),
    );
  }

  Widget get _title {
    var _theme = Theme.of(context);
    return GestureDetector(
      onTap: () {

      },
      child: _ownerNameText,
    )
        .addWidgetAsList(Text(
      ' / ${widget.trending.name}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: _theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      textAlign: TextAlign.start,
    ).nestedExpanded())
        .nestedRow();
  }

  Widget get _description {
    return Text(
      getDescription,
      textAlign: TextAlign.start,
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        wordSpacing: 0.6,
      ),
    ).nestedPadding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
    );
  }

  Widget get _languageBanner {
    return _language
        .addWidgetAsList(_stars)
        .addWidget(_forks)
        .nestedRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    )
        .nestedPadding(
      padding: const EdgeInsets.only(top: 4, bottom: 2, right: 24),
    );
  }

  Widget get _language {
    var _theme = Theme.of(context);
    return PhysicalModel(
      color: ColorUtil.color(
        _parseColorString(),
      ),
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(6),
      child: const SizedBox(
        width: 12,
        height: 12,
      ),
    )
        .nestedPadding(padding: const EdgeInsets.only(right: 2))
        .addWidgetAsList(Text(
      getPrimaryLanguage,
      style: TextStyle(
        color: _theme.iconTheme.color,
        fontWeight: FontWeight.w500,
      ),
    ))
        .nestedRow();
  }

  Widget get _stars {
    return const Icon(
      Icons.star,
      size: 16,
    )
        .nestedPadding(padding: const EdgeInsets.only(right: 2))
        .addWidgetAsList(Text(
      _processCount(widget.trending.stars),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    ))
        .nestedRow();
  }

  Widget get _forks {
    return const Icon(
      Icons.follow_the_signs,
      size: 16,
    )
        .nestedPadding(padding: const EdgeInsets.only(right: 2))
        .addWidgetAsList(Text(
      _processCount(widget.trending.forks),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    ))
        .nestedRow();
  }

  Widget get _ownerNameText {
    var _theme = Theme.of(context);
    return Text(
      widget.trending.author,
      style: TextStyle(
        color: _theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget get _numberIndex {
    var _theme = Theme.of(context);
    return Positioned(
      top: 0,
      right: 4,
      child: PhysicalModel(
        color: _theme.colorScheme.primary,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          alignment: Alignment.center,
          width: 18,
          height: 18,
          child: Text(
            '${widget.index}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBy(BuildContext context) {
    var buildBys = <Widget>[];
    widget.trending.builtBy.asMap().forEach(
          (index, buildBy) {
        buildBys.add(GestureDetector(
          onTap: () {

          },
          child: _buildBys(buildBy),
        ));
      },
    );
    if (buildBys.isEmpty) return Container();
    return Row(
      children: buildBys,
    );
  }

  Widget _buildBys(BuiltBy buildBy) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: CircleAvatar(
        radius: 12,
        child: ClipOval(
          child: Image.network(buildBy.avatar),
        ),
      ),
    );
  }

  String _parseColorString() {
    var colorStr = widget.trending.languageColor;
    var color = "";
    if (colorStr != null && colorStr.length == 4) {
      var strs = colorStr.substring(1).split("");

      for (var str in strs) {
        if (str.isNotEmpty) {
          color += (str + str);
        }
      }
    }
    return colorStr != null && colorStr.length == 4 ? color :(colorStr ?? '#cccccc');
  }

  String get getDescription {
    return widget.trending.description == null || widget.trending.description!.isEmpty
        ? 'No description given.'
        : widget.trending.description!;
  }

  String get getPrimaryLanguage {
    return widget.trending.language == null ||
        widget.trending.language!.isEmpty
        ? 'Unknown'
        : widget.trending.language!;
  }

  String _processCount(int count) {
    if (count < 1000) return count.toString();
    return (count / 1000).toStringAsFixed(1) + 'k';
  }
}
