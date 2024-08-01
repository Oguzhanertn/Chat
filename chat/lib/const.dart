// ignore_for_file: non_constant_identifier_names, prefer_const_declarations

final RegExp EMAIL_VALIDATION_REGEX =
    RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

final RegExp PASSWORD_VALIDATION_REGEX = RegExp(r"^(?=.*?[0-9]),{6,}$");

final RegExp NAME_VALIDATION_REGEX = RegExp(r"\b([A-ZA-y][-,a-z. ']+[ ]*)+");

final String PLACEHOLDER_PFP =
    "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg";
