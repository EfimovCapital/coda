module Styles = {
  open Css;

  let square = (bgColor, textColor, borderColor) =>
    style([
      display(`flex),
      flexDirection(`column),
      justifyContent(`flexStart),
      alignItems(`center),
      height(`rem(23.)),
      width(`rem(23.)),
      backgroundColor(bgColor),
      selector("h1", [color(textColor), fontFamily(Fonts.ibmplexsans)]),
      borderRadius(`px(6)),
      border(`px(2), `solid, borderColor),
      boxShadow(
        Shadow.box(
          ~x=`zero,
          ~y=`px(10),
          ~blur=`px(30),
          `rgba((61, 88, 120, 0.25)),
        ),
      ),
    ]);

  let blockText = textColor =>
    style([
      marginTop(`zero),
      height(`rem(20.)),
      width(`rem(20.)),
      overflowWrap(`breakWord),
      fontFamily(Fonts.ocrastud),
      fontSize(`rem(1.56)),
      color(textColor),
    ]);

  let heading = style([fontFamily("Aktiv Grotesk Bold")]);
};

[@react.component]
let make =
    (~bgColor, ~textColor, ~borderColor, ~heading, ~text, ~active=false) =>
  <div
    className={
      active
        ? Styles.square(
            Colors.thirdBgActive,
            Colors.offWhite,
            Colors.thirdBgActive,
          )
        : Styles.square(bgColor, textColor, borderColor)
    }>
    <h1 className=Styles.heading> {React.string(heading)} </h1>
    <div className={Styles.blockText(textColor)}> text </div>
  </div>;