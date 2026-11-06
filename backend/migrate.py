import requests
from sqlalchemy.orm import Session
from database import engine, SessionLocal, Base
import models

SUPABASE_URL = 'https://tiornpjjrtajnmgvoqfb.supabase.co'
SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRpb3JucGpqcnRham5tZ3ZvcWZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQzNzU3NTQsImV4cCI6MjA5OTk1MTc1NH0.KRiPpKDR8D1HKItFwBqb93Y5bLkLQTJWDA8fUchyd_E'

headers = {
    'apikey': SUPABASE_KEY,
    'Authorization': f'Bearer {SUPABASE_KEY}'
}

db = SessionLocal()
Base.metadata.create_all(bind=engine)

def fetch_and_insert(table_name, model_class):
    print(f"Migrating {table_name}...")
    response = requests.get(f"{SUPABASE_URL}/rest/v1/{table_name}?select=*", headers=headers)
    if response.status_code == 200:
        data = response.json()
        for item in data:
            instance = model_class()
            for key, value in item.items():
                if hasattr(instance, key):
                    setattr(instance, key, value)
            db.merge(instance)
        db.commit()
        print(f"Successfully migrated {len(data)} items for {table_name}")
    else:
        print(f"Failed to fetch {table_name}: {response.text}")

fetch_and_insert('site_content', models.SiteContent)
fetch_and_insert('payment_methods', models.PaymentMethod)
fetch_and_insert('sections', models.Section)
fetch_and_insert('features', models.Feature)
fetch_and_insert('trainers', models.Trainer)
fetch_and_insert('curriculum', models.Curriculum)
fetch_and_insert('faqs', models.FAQ)

print("Migration completed!")
