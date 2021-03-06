from django.contrib import admin

from .models import *


class ChoiceInline(admin.TabularInline):
    model = Choice
    extra = 3


class QuestionAdmin(admin.ModelAdmin):
    fieldsets = [
        (None, {"fields": ["text"]}),
        ("Date information", {"fields": ["date"]}),
    ]
    inlines = [ChoiceInline]
    list_display = ("text", "date", "was_published_recently")
    list_filter = ["date"]
    search_fields = ["text"]


admin.site.register(Question, QuestionAdmin)
