/*!
 * Farbtastic: jQuery color picker plug-in v1.3u
 *
 * Licensed under the GPL license:
 *   http://www.gnu.org/licenses/gpl.html
 */
(function (a) {
    a.fn.farbtastic = function (b) {
        a.farbtastic(this, b);
        return this
    };
    a.farbtastic = function (b, c) {
        var b = a(b).get(0);
        return b.farbtastic || (b.farbtastic = new a._farbtastic(b, c))
    };
    a._farbtastic = function (b, f) {
        var c = this;
        a(b).html('<div class="farbtastic"><div class="color"></div><div class="wheel"></div><div class="overlay"></div><div class="h-marker marker"></div><div class="sl-marker marker"></div></div>');
        var d = a(".farbtastic", b);
        c.wheel = a(".wheel", b).get(0);
        c.radius = 84;
        c.square = 100;
        c.width = 194;
        if (navigator.appVersion.match(/MSIE [0-6]\./)) {
            a("*", d).each(function () {
                if (this.currentStyle.backgroundImage != "none") {
                    var e = this.currentStyle.backgroundImage;
                    e = this.currentStyle.backgroundImage.substring(5, e.length - 2);
                    a(this).css({
                        backgroundImage: "none",
                        filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, sizingMethod=crop, src='" + e + "')"
                    })
                }
            })
        }
        c.linkTo = function (e) {
            if (typeof c.callback == "object") {
                a(c.callback).unbind("keyup", c.updateValue)
            }
            c.color = null;
            if (typeof e == "function") {
                c.callback = e
            } else {
                if (typeof e == "object" || typeof e == "string") {
                    c.callback = a(e);
                    c.callback.bind("keyup", c.updateValue);
                    if (c.callback.get(0).value) {
                        c.setColor(c.callback.get(0).value)
                    }
                }
            }
            return this
        };
        c.updateValue = function (e) {
            if (this.value && this.value != c.color) {
                c.setColor(this.value)
            }
        };
        c.setColor = function (e) {
            var g = c.unpack(e);
            if (c.color != e && g) {
                c.color = e;
                c.rgb = g;
                c.hsl = c.RGBToHSL(c.rgb);
                c.updateDisplay()
            }
            return this
        };
        c.setHSL = function (e) {
            c.hsl = e;
            c.rgb = c.HSLToRGB(e);
            c.color = c.pack(c.rgb);
            c.updateDisplay();
            return this
        };
        c.widgetCoords = function (e) {
            var g = a(c.wheel).offset();
            return {
                x: (e.pageX - g.left) - c.width / 2,
                y: (e.pageY - g.top) - c.width / 2
            }
        };
        c.mousedown = function (e) {
            if (!document.dragging) {
                a(document).bind("mousemove", c.mousemove).bind("mouseup", c.mouseup);
                document.dragging = true
            }
            var g = c.widgetCoords(e);
            c.circleDrag = Math.max(Math.abs(g.x), Math.abs(g.y)) * 2 > c.square;
            c.mousemove(e);
            return false
        };
        c.mousemove = function (i) {
            var j = c.widgetCoords(i);
            if (c.circleDrag) {
                var h = Math.atan2(j.x, -j.y) / 6.28;
                if (h < 0) {
                    h += 1
                }
                c.setHSL([h, c.hsl[1], c.hsl[2]])
            } else {
                var g = Math.max(0, Math.min(1, -(j.x / c.square) + 0.5));
                var e = Math.max(0, Math.min(1, -(j.y / c.square) + 0.5));
                c.setHSL([c.hsl[0], g, e])
            }
            return false
        };
        c.mouseup = function () {
            a(document).unbind("mousemove", c.mousemove);
            a(document).unbind("mouseup", c.mouseup);
            document.dragging = false
        };
        c.updateDisplay = function () {
            var e = c.hsl[0] * 6.28;
            a(".h-marker", d).css({
                left: Math.round(Math.sin(e) * c.radius + c.width / 2) + "px",
                top: Math.round(-Math.cos(e) * c.radius + c.width / 2) + "px"
            });
            a(".sl-marker", d).css({
                left: Math.round(c.square * (0.5 - c.hsl[1]) + c.width / 2) + "px",
                top: Math.round(c.square * (0.5 - c.hsl[2]) + c.width / 2) + "px"
            });
            a(".color", d).css("backgroundColor", c.pack(c.HSLToRGB([c.hsl[0], 1, 0.5])));
            if (typeof c.callback == "object") {
                a(c.callback).css({
                    backgroundColor: c.color,
                    color: c.hsl[2] > 0.5 ? "#000" : "#fff"
                });
                a(c.callback).each(function () {
                    if (this.value && this.value != c.color) {
                        this.value = c.color
                    }
                })
            } else {
                if (typeof c.callback == "function") {
                    c.callback.call(c, c.color)
                }
            }
        };
        c.pack = function (h) {
            var j = Math.round(h[0] * 255);
            var i = Math.round(h[1] * 255);
            var e = Math.round(h[2] * 255);
            return "#" + (j < 16 ? "0" : "") + j.toString(16) + (i < 16 ? "0" : "") + i.toString(16) + (e < 16 ? "0" : "") + e.toString(16)
        };
        c.unpack = function (e) {
            if (e.length == 7) {
                return [parseInt("0x" + e.substring(1, 3)) / 255, parseInt("0x" + e.substring(3, 5)) / 255, parseInt("0x" + e.substring(5, 7)) / 255]
            } else {
                if (e.length == 4) {
                    return [parseInt("0x" + e.substring(1, 2)) / 15, parseInt("0x" + e.substring(2, 3)) / 15, parseInt("0x" + e.substring(3, 4)) / 15]
                }
            }
        };
        c.HSLToRGB = function (n) {
            var p, o, e, k, m;
            var j = n[0],
                q = n[1],
                i = n[2];
            o = (i <= 0.5) ? i * (q + 1) : i + q - i * q;
            p = i * 2 - o;
            return [this.hueToRGB(p, o, j + 0.33333), this.hueToRGB(p, o, j), this.hueToRGB(p, o, j - 0.33333)]
        };
        c.hueToRGB = function (g, e, i) {
            i = (i < 0) ? i + 1 : ((i > 1) ? i - 1 : i);
            if (i * 6 < 1) {
                return g + (e - g) * i * 6
            }
            if (i * 2 < 1) {
                return e
            }
            if (i * 3 < 2) {
                return g + (e - g) * (0.66666 - i) * 6
            }
            return g
        };
        c.RGBToHSL = function (n) {
            var j, p, q, k, t, i;
            var e = n[0],
                m = n[1],
                o = n[2];
            j = Math.min(e, Math.min(m, o));
            p = Math.max(e, Math.max(m, o));
            q = p - j;
            i = (j + p) / 2;
            t = 0;
            if (i > 0 && i < 1) {
                t = q / (i < 0.5 ? (2 * i) : (2 - 2 * i))
            }
            k = 0;
            if (q > 0) {
                if (p == e && p != m) {
                    k += (m - o) / q
                }
                if (p == m && p != o) {
                    k += (2 + (o - e) / q)
                }
                if (p == o && p != e) {
                    k += (4 + (e - m) / q)
                }
                k /= 6
            }
            return [k, t, i]
        };
        a("*", d).mousedown(c.mousedown);
        c.setColor("#000000");
        if (f) {
            c.linkTo(f)
        }
    }
})(jQuery);
$(document).ready(function () {
    var a = $.farbtastic("#colorpicker");
    $("input.color_option").each(function () {
        a.linkTo(this)
    }).focus(function () {
        $("#colorpicker_wrapper").show().position({
            my: "right center",
            at: "left center",
            offset: "100 100",
            of: $(this),
            collision: "none"
        });
        var b = $(this);
         a.linkTo(function (c) {
            b.css({
                "background-color": c,
                color: a.hsl[2] > 0.5 ? "#181818" : "#fefefe"
            });
            b.val(a.color);
            if (b.attr("id") == "question_style_background") {
                $(".bg-prev-question").css({
                    "background-color": c
                })
            }
             if (b.attr("id") == "question_style_answers") {
                $("#answers").css({
                    "color": c
                })
            }
            if (b.attr("id") == "question_style_page_header") {
                $("#company_name").css({
                    color: c
                })
            } else {
                if (b.attr("id") == "question_style_question_text") {
                    $("#qs-title").css({
                        color: c
                    });
                    $("body").css({
                        borderColor: c
                    })
                } else {
                    if (b.attr("id") == "question_style_submit_button") {
                        $("#submit,customization, #upload_logo_button").css({
                            "background-color": c
                        })
                    } else {
                        if (b.attr("id") == "question_style_button_text") {
                            $("#submit, #save_customization, #upload_logo_button").css({
                                color: c
                            })
                        }
                    }
                }
            }
        });
        a.setColor($(this).val());
        $("input.color_option").change()
    });
    $("input.color_option").keyup(function () {
        a.linkTo(this);
        var b = $(this);
        a.linkTo(function (c) {
            b.css({
                "background-color": c,
                color: a.hsl[2] > 0.5 ? "#181818" : "#fefefe"
            });
            b.val(a.color);
            if (b.attr("id") == "question_background_color") {
                $("body").css({
                    "background-color": c
                })
            }
            if (b.attr("id") == "question_question_text_color") {
                $("#question_area h2").css({
                    color: c
                })
            } else {
                if (b.attr("id") == "question_style_page_header") {
                    $("#question_style_page_header").css({
                        color: c
                    });
                    $("body").css({
                        borderColor: c
                    })
                } else {
                    if (b.attr("id") == "question_button_bg_color") {
                        $("#example_submit_button, #save_customization, #upload_logo_button").css({
                            "background-color": c
                        })
                    } else {
                        if (b.attr("id") == "question_button_text_color") {
                            $("#example_submit_button, #save_customization, #upload_logo_button").css({
                                color: c
                            })
                        }
                    }
                }
            }
        });
        a.setColor($(this).val());
        $("input.color_option").change()
    });
    $("html").click(function () {
        if ($("#colorpicker_wrapper").is(":visible")) {
            $("#colorpicker_wrapper").hide()
        }
    });
    $("#colorpicker_wrapper, input.color_option").click(function (b) {
        b.stopPropagation()
    });
    $("#question_use_black_controls_false, #question_use_black_controls_true").change(function () {
        if ($("#question_use_black_controls_false").is(":checked")) {
            $("label").css("color", "#fefefe");
            $("div.answer_radio").removeClass("use_black");
            $(".submit_response").removeClass("use_black");
            $("#save_reminder").removeClass("use_black");
            $("#back_to_dash_button a").removeClass("use_black");
            $("#upload_logo_trigger").removeClass("use_black");
            $("a.powered_by_inquirly").removeClass("use_black")
        } else {
            if ($("#question_use_black_controls_true").is(":checked")) {
                $("label").css("color", "#181818");
                $("div.answer_radio").addClass("use_black");
                $(".submit_response").addClass("use_black");
                $("#save_reminder").addClass("use_black");
                $("#back_to_dash_button a").addClass("use_black");
                $("#upload_logo_trigger").addClass("use_black");
                $("a.powered_by_inquirly").addClass("use_black")
            }
        }
    });
    $("a.dark_light_toggle").click(function () {
        if ($(this).hasClass("use_black")) {
            $(this).removeClass("use_black");
            $("#question_use_black_controls_false").attr("checked", true).change()
        } else {
            $(this).addClass("use_black");
            $("#question_use_black_controls_true").attr("checked", true).change()
        }
        return false
    });
    $("a.font_toggle").click(function () {
        if ($(this).hasClass("use_serif")) {
            $(this).removeClass("use_serif");
            $("#question_use_serif_false").attr("checked", true).change()
        } else {
            $(this).addClass("use_serif");
            $("#question_use_serif_true").attr("checked", true).change()
        }
        return false
    });
    $("#question_use_serif_false, #question_use_serif_true").change(function () {
        if ($("#question_use_serif_false").is(":checked")) {
            $("#question_name_header").removeClass("use_serif");
            $("#question_area h2").removeClass("use_serif");
            $("#response_area label").removeClass("use_serif")
        } else {
            if ($("#question_use_serif_true").is(":checked")) {
                $("#company_name_header").addClass("use_serif");
                $("#question_area h2").addClass("use_serif");
                $("#response_area label").addClass("use_serif")
            }
        }
    });
    $("a.submit_response.demo").click(function () {
        return false
    });
    $("input.color_option, #question_use_black_controls_false, #question_use_black_controls_true").change(function () {
        $("#save_reminder").fadeIn().position({
            my: "right center",
            at: "left center",
            offset: "-40 0",
            of: $("#save_customization"),
            collision: "none"
        })
    });
    $("a#upload_logo_trigger").click(function () {
        if ($("#logo_upload_form").is(":visible")) {
            $("#logo_upload_form").hide()
        } else {
            $("#logo_upload_form").show()
        }
        return false
    })
});
$(document).ready(function () {
    $("div.answer_radio, div.response_thumb").click(function () {
        $(this).prev("div.browser_radio").find("input:radio").attr("checked", true);
        $("input:radio").change()
    });
    $("label.answer_label").click(function () {
        if (!$(this).closest("div.field").find("input:radio").is(":checked")) {
            $("div.answer_radio").removeClass("checked");
            $("div.response_thumb").removeClass("active")
        }
    });
    $("input:radio").change(function () {
        if ($(this).is(":checked")) {
            $(this).closest("div.field").find("div.answer_radio").addClass("checked");
            $(this).closest("div.field").find("div.response_thumb").addClass("active")
        } else {
            $(this).closest("div.field").find("div.answer_radio").removeClass("checked");
            $(this).closest("div.field").find("div.response_thumb").removeClass("active")
        } if ($(this).attr("id") == "response_answers_attributes_0_content_other") {
            if ($(this).is(":checked")) {
                $(this).closest("div.field").find("input.public_other_field").removeAttr("disabled");
                $(this).closest("div.field").find("input.public_other_field").removeClass("disabled")
            } else {
                $(this).closest("div.field").find("input.public_other_field").attr("disabled", "disabled");
                $(this).closest("div.field").find("input.public_other_field").addClass("disabled")
            }
        }
    });
    $("div.answer_check_box").click(function () {
        if ($(this).hasClass("checked")) {
            $(this).prev("div.browser_check_box").find("input:checkbox").attr("checked", false)
        } else {
            $(this).prev("div.browser_check_box").find("input:checkbox").attr("checked", true)
        }
        $("input:checkbox").change()
    });
    $("input:checkbox").change(function () {
        if ($(this).is(":checked")) {
            $(this).closest("div.field").find("div.answer_check_box").addClass("checked");
            $(this).closest("div.field").find("input:hidden").first().removeAttr("disabled")
        } else {
            $(this).closest("div.field").find("div.answer_check_box").removeClass("checked");
            $(this).closest("div.field").find("input:hidden").first().attr("disabled", "disabled")
        } if ($(this).attr("id") == "make_this_other") {
            if ($(this).is(":checked")) {
                $(this).closest("div.field").find("input.public_other_field").removeAttr("disabled");
                $(this).closest("div.field").find("input.public_other_field").removeClass("disabled")
            } else {
                $(this).closest("div.field").find("input.public_other_field").attr("disabled", "disabled");
                $(this).closest("div.field").find("input.public_other_field").addClass("disabled")
            }
        }
    });
    $("#response_area input.thumb_checker").click(function () {
        $("div.response_thumb").removeClass("active");
        $(this).closest("div.field").find("div.response_thumb").addClass("active")
    });
    $("label.answer_label").mouseenter(function () {
        if (!$(this).closest("div.field").find("input:radio").is(":checked") || !$(this).closest("div.field").find("input:checkbox").is(":checked")) {
            $(this).prev().addClass("hover_state")
        }
    });
    $("label.answer_label").mouseout(function () {
        $(this).prev().removeClass("hover_state")
    })
});