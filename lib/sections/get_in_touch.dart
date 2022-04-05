import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/components/reactive_input_field.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';
import 'dart:js' as js;

import 'package:flutter_my_portfolio/services/send_email.dart';
import 'package:http/http.dart';
import 'package:reactive_forms/reactive_forms.dart';

class GetInTouchSection extends StatefulWidget {
  final String? title;
  const GetInTouchSection({Key? key, this.title}) : super(key: key);

  @override
  State<GetInTouchSection> createState() => _GetInTouchSectionState();
}

class _GetInTouchSectionState extends State<GetInTouchSection> {
  final contactForm = FormGroup({
    'email': FormControl(
      value: '',
      validators: [
        Validators.required,
        Validators.email,
        Validators.maxLength(62)
      ],
      asyncValidatorsDebounceTime: 800,
    ),
    'name': FormControl(
      value: '',
      validators: [
        Validators.required,
      ],
    ),
    'message': FormControl(
      value: '',
      validators: [
        Validators.required,
        // Validators.minLength(6),
      ],
    ),
    'subject': FormControl(
      value: '',
      validators: [
        Validators.required,
      ],
    ),
  });

  bool isSubmitting = false;

  @override
  void dispose() {
    super.dispose();
  }

  void toggleIsSubmitting(bool value) {
    setState(() {
      this.isSubmitting = value;
    });
  }

  Widget buildTextFormField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kButtonColor, width: 1.0),
          borderRadius: BorderRadius.circular(18),
        ),
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: maxLines == 1 ? 0 : 12,
        ),
      ),
      style: TextStyle(fontSize: 14),
      cursorColor: kButtonColor,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'The field is required';
        } else if (isEmail &&
            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return "Invalid email";
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton() {
    return ReactiveFormConsumer(builder: (context, form, child) {
      bool invalid = form.invalid;
      return MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        onPressed: invalid ? () {} : submit,
        color: invalid || isSubmitting ? Colors.grey : kButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          this.isSubmitting ? "Submitting..." : "Submit Message",
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }

  void submit() async {
    if (!isSubmitting) {
      try {
        toggleIsSubmitting(true);
        Response response = await sendEmail(
          contactForm.control('name').value,
          contactForm.control('email').value,
          contactForm.control('message').value,
          contactForm.control('subject').value,
        );
        final statusCode = response.statusCode;
        if (statusCode == 200) {
          Scaffold.of(context).showSnackBar(
            const SnackBar(
              content: Text("Thanks for your message. Will check on that. :D"),
              backgroundColor: Colors.green,
            ),
          );
          contactForm.reset();
        } else {
          Scaffold.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong."),
              backgroundColor: Colors.red,
            ),
          );
        }
        toggleIsSubmitting(false);
      } on Exception catch (e) {
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong."),
            backgroundColor: Colors.red,
          ),
        );
        toggleIsSubmitting(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: contactForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text('${widget.title}', style: kHeadline3),
          Container(
            height: 8,
            width: 40,
            margin: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(color: kColorLavender),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact No.',
                    style: kTextSub.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        // mailto:support@email.com?
                        js.context
                            .callMethod('open', ['tel:${Data.PHONE_NUMBER}']);
                      },
                      child: Text(
                        Data.PHONE_NUMBER,
                        style: kTextBody.copyWith(
                            fontWeight: FontWeight.w400, color: kColorBlue),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Email',
                    style: kTextSub.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        // mailto:support@email.com?
                        js.context.callMethod('open', ['mailto:${Data.EMAIL}']);
                      },
                      child: Text(
                        Data.EMAIL,
                        style: kTextBody.copyWith(
                          fontWeight: FontWeight.w400,
                          color: kColorBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 25,
              ),
              Expanded(
                child: Column(
                  children: [
                    ReactiveInputField(
                      padding: EdgeInsets.zero,
                      formControlName: 'name',
                      validationMessages: (control) {
                        Map errors = control.errors;
                        int maxlength = 0;
                        if (errors['maxLength'] != null) {
                          maxlength = errors['maxLength']['requiredLength'];
                        }

                        return {
                          'required': 'This field is required',
                          'maxLength':
                              'This field must have less than $maxlength characters'
                        };
                      },
                      withBorder: true,
                      title: 'Your name',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ReactiveInputField(
                      padding: EdgeInsets.zero,
                      formControlName: 'email',
                      validationMessages: (control) {
                        Map errors = control.errors;
                        int maxlength = 0;
                        if (errors['maxLength'] != null) {
                          maxlength = errors['maxLength']['requiredLength'];
                        }

                        return {
                          'required': 'This field is required',
                          'email': 'Invalid format.',
                          'maxLength':
                              'This field must have less than $maxlength characters'
                        };
                      },
                      withBorder: true,
                      title: 'Your Email',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ReactiveInputField(
                      padding: EdgeInsets.zero,
                      formControlName: 'subject',
                      validationMessages: (control) {
                        Map errors = control.errors;
                        int maxlength = 0;
                        if (errors['maxLength'] != null) {
                          maxlength = errors['maxLength']['requiredLength'];
                        }

                        return {
                          'required': 'This field is required',
                          'maxLength':
                              'This field must have less than $maxlength characters'
                        };
                      },
                      withBorder: true,
                      title: 'Subject',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ReactiveInputField(
                      padding: EdgeInsets.zero,
                      formControlName: 'message',
                      validationMessages: (control) {
                        Map errors = control.errors;
                        int maxlength = 0;
                        if (errors['maxLength'] != null) {
                          maxlength = errors['maxLength']['requiredLength'];
                        }

                        return {
                          'required': 'This field is required',
                          'maxLength':
                              'This field must have less than $maxlength characters'
                        };
                      },
                      withBorder: true,
                      title: 'Message',
                      maxLines: 4,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildSubmitButton()
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
