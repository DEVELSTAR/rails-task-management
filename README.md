# README

## ✅ **Project Overview Summary**

### 🔐 **Authentication System**

* **User model** with:

  * Email & secure password (`has_secure_password`)
  * No external gems like Devise
* **AdminUser** model for ActiveAdmin authentication

---

### 🎛 **Admin Panel**

* **ActiveAdmin** is integrated
* Admin resources for:

  * `User`
  * `AdminUser`
  * `Task`
  * `CatFact`
  * `QuranVerse`
* **Dashboard customizations**:

  * Total counts for users, tasks, admins
  * Task status breakdown
  * Recent tasks
  * Live data from third-party APIs (cat facts, Quran)

---

### 📋 **Task Management**

* `Task` model includes:

  * `title`, `description`, `status` (default: "todo"), `due_date`
  * Associated with `User`
* Paginated and serialized in API
* Shown in ActiveAdmin with time formatting helpers (`x minutes ago` or formatted date)

---

### 🐱 **Third-Party API Integration - Cat Facts**

* **API**: [catfact.ninja](https://catfact.ninja)
* Saved to `cat_facts` table:

  * `fact`, `source`, timestamps
* Error-handled fetching
* Shown in admin & dashboard

---

### 📖 **Third-Party API Integration - Quran Verses**

* API with support for **language selection**
* Saved to `quran_verses` table:

  * `surah_name`, `verse_number`, `text`, `source`, `language`
* Admin interface includes:

  * Dropdown for language selection
  * Manual fetch via button
  * CRUD support

---

### 🧱 **Supporting Structure**

* **Services** used to encapsulate external API logic (`CatFactFetcherService`, `QuranVerseFetcherService`)
* **Concerns** used for DRY pagination (`Paginatable`)
* **Helpers** used for formatting time (`AdminHelper#formatted_time_ago`)
* **SimpleCov** used for test coverage tracking

---

### 🧪 **Testing & Code Quality**

* `simplecov` gem tracks test coverage
* `rubocop` enforces code style and linting (Auto-correct available via `rubocop -A`)
* `brakeman` scans for security vulnerabilities in the codebase

---

### Ignore Files

* View untracked, non-ignored files:

  ```bash
  git ls-files --others --exclude-standard
  ```

* View ignored files:

  ```bash
  git status --ignored
  ```

* Remove tracked files that should be ignored:

  ```bash
  git rm --cached path/to/file
  git commit -m "Remove ignored file"
  ```

---

## ✅ Summary Tags

```
✅ Auth (Custom)
✅ Admin Panel (ActiveAdmin)
✅ Task Management
✅ Cat Facts API
✅ Quran API (Lang support)
✅ DRY Code: Services, Helpers, Concerns
✅ Dashboard Stats & Live API
✅ Testing Coverage (SimpleCov)
✅ Code Linting (Rubocop)
✅ Security Audit (Brakeman)
```

---